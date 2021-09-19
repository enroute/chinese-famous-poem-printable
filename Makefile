all:
	#perl sort.pl tang.txt > tang.sort
	#perl sort.pl song.txt > song.sort
	#perl sort.pl ming.txt > ming.sort
	#cat han.txt tang.sort song.sort ming.sort > db.txt
	#perl sort.pl db.txt > db.sort
	#perl gen.pl han.txt tang.sort song.sort ming.sort > db.tex
	#perl gen.pl db.sort > db.tex
	perl gen.pl 1-shijing.txt  2-qinhan.txt 22-weijin.txt 3-tang.txt 6-wudai.txt 4-song.txt 5-yuan.txt 6-ming.txt 7-qing.txt 9-near.txt > db.tex
	xelatex master
	xelatex master