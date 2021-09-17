#!/usr/bin/perl -w
use strict;
use warnings;

my $empty = 0;
my %poems = ();
my $author;
my $content;
while(<>){
  if (/^[ \t\r\n]*$/) {
    $empty += 1;
  } else {
    if (!/^#/) {
      $empty = 0;
    }
  }

  if ($empty >= 2) {
    if (defined $author) {
      $poems{$author} = [] if not defined $poems{$author};
      push @{$poems{$author}}, $content;
      $author = undef;
      $content = undef;
    }
  } else {
    if (not defined $content) {
      if (! /^[ \t\r\n]*$/) {
        $content = $_;
      }
    } else {
      $content .= $_;
      if (not defined $author) {
        if (! /^[ \t\r\n]*$|^#/) {
          $author = $_;
          $author =~ s/\[.*\]//g;

          #print("===>$author***$content]]]]\n\n");
        }
      }
    }
  }
}

print("\n\n\n");
foreach my $k (keys %poems) {
  for my $c (@{$poems{$k}}) {
    print("$c\n\n\n");
  }
}