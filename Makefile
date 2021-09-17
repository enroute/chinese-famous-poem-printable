all:
	#perl sort.pl tang.txt > tang.sort
	#perl sort.pl song.txt > song.sort
	#perl sort.pl ming.txt > ming.sort
	#cat han.txt tang.sort song.sort ming.sort > db.txt
	perl sort.pl db.txt > db.sort
	#perl gen.pl han.txt tang.sort song.sort ming.sort > db.tex
	perl gen.pl db.sort > db.tex
	xelatex master
	xelatex master