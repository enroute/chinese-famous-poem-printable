all:
	perl sort.pl tang.txt > tang.sort
	perl sort.pl song.txt > song.sort
	perl sort.pl ming.txt > ming.sort
	perl gen.pl han.txt tang.sort song.sort ming.sort > db.tex
	xelatex master
	xelatex master