#!/usr/bin/perl -w
use strict;
use warnings;

my ($title, $author, $empty);
my @text;

# use @{} to remove the col separation on left and right
my $template = <<"EOF";
\\ptitle{<TITLE>}\\nopagebreak%
\\addcontentsline{toc}{section}{<TOCTITLE>}\\nopagebreak%
\\noindent\\begin{minipage}{\\linewidth}
  \\pauthor{<AUTHOR>}
  \\vskip-3pt\\begin{table}[H]
    \\centering
    \\begin{tabular}{\@\{\}l\@\{\}}
<TEXT>
    \\end{tabular}
  \\end{table}
\\end{minipage}
\\vspace{1cm}
EOF

sub replace_pinyin1 {
  my ($text, $py) = @_;
  my $py_tpl = '\xpinyin*{\xpinyin{<WORD>}{<PINYIN>}}';
  $py_tpl =~ s/<WORD>/$text/;
  $py_tpl =~ s/<PINYIN>/$py/;
  return $py_tpl;
}

sub replace_pinyin2 {
  my ($t1, $t2, $p1, $p2) = @_;
  my $py_tpl1 = "\\xpinyin*{\\xpinyin{$t1}{$p1}}";
  my $py_tpl2 = "\\xpinyin*{\\xpinyin{$t2}{$p2}}";
  return $py_tpl1.$py_tpl2;
}

sub print_item {
  my ($title, $author, $textref) = @_;
  if (not defined $title or not defined $author or not defined $textref) {
    print("ERROR!!!\n");
    return;
  }

  my $output = $template;

    # for string in pdf bookmark, which has limited command support
  my $toc_pdf_string = "$title\\ $author";
  # remove the pinyin
  $toc_pdf_string =~ s/\[.*?\]//g;

  my $toc_title = "{$title\\dotfill{} $author}";
  #$toc_title =~ s/【.*】//;
  $toc_title =~ s/\[.*?\]//g;
  $toc_title = '\texorpdfstring{\makebox[10cm]' . $toc_title . "}{$toc_pdf_string}";
  $output =~ s/<TOCTITLE>/$toc_title/e;

  $title =~ s/(...)\[([^ ]*?)\]/replace_pinyin1($1, $2)/egs;
  $title =~ s/(...)(...)\[([^ ]*?)[ ]+([^ ]*?)\]/replace_pinyin2($1, $2, $3, $4)/egs;

  $author =~ s/(...)\[([^ ]*?)\]/replace_pinyin1($1, $2)/egs;
  $author =~ s/(...)(...)\[([^ ]*?)[ ]+([^ ]*?)\]/replace_pinyin2($1, $2, $3, $4)/egs;

  $output =~ s/<TITLE>/$title/e;
  $output =~ s/<AUTHOR>/$author/e;

  my @text = @$textref;
  my $text = join("\n", @text);
  $text =~ s/^[ \t\r\n]+|[ \t\r\n]+$//gs;
  #$text =~ s/\n\n+/\n/gs;
  $text =~ s/\n/\\\\\n/g;

  # replace pinyin, Chinese characters has 3 bytes
  $text =~ s/(...)\[([^ ]*?)\]/replace_pinyin1($1, $2)/egs;
  $text =~ s/(...)(...)\[([^ ]*?)[ ]+([^ ]*?)\]/replace_pinyin2($1, $2, $3, $4)/egs;

  $output =~ s/<TEXT>/$text/e;
  print("$output\n\n");
}

print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");
print("% This file is generated automatically.\n");
print("% DO NOT MODIFY IT IF YOU DON'T KNOW.\n");
print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n");

$empty = 0;
while(<>){
  s/^[ \t\r\n]+|[ \t\r\n]+$//g;
  next if /^#/; # ignore lines start with #
  if (/^$/) {
    $empty += 1;
    if ($empty >= 2 || not defined($title)) {
      if (@text && defined $title) {
        print_item($title, $author, \@text);
      }
      $title = undef;
      $author = undef;
      @text = undef;
      $empty = 0;
      next;
    }
  } else {
    $empty = 0;
  }

  if (not defined $title) {
    $title = $_;
    @text=();
  } elsif (not defined $author) {
    $author = $_;
    $author =~ s/^(.*?)[ \t]+(.*)$/【$1】$2/;
  } else {
    push @text, $_;
  }
}

# the last one
print_item($title, $author, \@text);

__END__
# Usage:
# perl gen.pl db.txt > db.tex