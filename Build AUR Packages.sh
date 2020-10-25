#!/bin/bash

#Building packages I like (Dylan)

num_programs=2

cd ~
mkdir tmp
cd tmp 
echo install up to $num_programs AUR programs, exit by pressing Ctrl+C 

for i in {1..$num_programs}
	do	  
	read -p 'please enter a valid AUR package name: ' program1
	git clone https://aur.archlinux.org/$program1.git
	cd $program1
	makepkg -Acs
	sudo pacman -U *.pkg.tar.*
	cd ..
#run after install only for vivaldi 
	if [$program1 = vivaldi]
	then	
		sudo /opt/vivaldi/update-ffmpeg
	fi

done 
cd ~
rm -rf tmp 


