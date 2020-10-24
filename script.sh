#!/usr/bin/bash

num=1
newFile=Y
while [ "$num" -ne 0 ]
do
	echo
	echo "----MENU---- "
	echo
	echo "Choose one of the options below "
	echo "1) ADD A NEW REPOSITORY"
	echo "2) ADD A NEW FILE"
	echo "3) SEE CURRENT REPOSITORIES AND FILES IN THE WORKING DIRECTORY "
	echo "0) Exits"
	read num

	case $num in
		1 ) read -p "Enter a name of a repository: " entry
		    mkdir $entry
		    echo "$entry repository created " >>  log.txt
		    cd $entry
		    echo
		    while [ $newFile = 'Y' ] || [ $newFile = 'y' ]
		    do
			echo "Add a new file to a repository"
			echo "y - Yes "
			echo "n - No"
			read newFile
			case $newFile in
				y|Y ) read -p "Enter a name of a file: " fname
					touch  $fname
					echo "$fname file created in $entry" >> log.txt
					;;
				n|N ) break
					;;
				* ) echo "Invalid input"
				    newFile=Y	
					;;
			esac
		    done
			;;
		0 ) break 
			;;
		* ) echo "Invalid input"
			;;
	esac
done
