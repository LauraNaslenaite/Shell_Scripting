#!/usr/bin/bash

num=1
newFile=Y
number_of_files=0
entry2=1
entry3=1
entry4=1
while [ $num -ne 0 ]
do
	echo
	echo "----------------MENU---------------- "
	echo
	echo "Choose one of the options below "
	echo " 1 - ADD A NEW REPOSITORY"
	echo " 2 - CHECK CURRENT REPOSITORIES"
	echo " 3 - RECENT UPDATES "
	echo " 4 - LOG IN HISTORY"
	echo " 0 - Exit"
	echo "-----------------------------------"
	read num
	echo
	case $num in
		1 ) read -p "Enter a name for a repository: " entry
			while [ -d $entry ]
			do 
				echo "A repository with such a name already exists"
				read -p "Enter a new name for a repository: " entry
			done
			mkdir $entry
			echo "'$entry' repository created " >>  log.txt
			cd $entry
			echo
			while [ $number_of_files -eq 0 ]
			do
				echo "Add a new file to a repository"
				echo "y - Yes "
				echo "n - No"
				read newFile
				case $newFile in
					y|Y ) read -p "Enter a name of a file: " fname
							touch  $fname
							echo "'$fname' file created in $entry" >> log.txt
							((number_of_files++))
							;;
					n|N ) break
							;;
					* ) echo "Invalid input"
							;;
				esac
			done
				
			if [ $number_of_files -eq 1 ]
			then
				while [ $entry2 -ne 0 ]
				do
					echo
					echo " 1 - Add a new file to a repository"
					echo " 2 - Edit a file "
					echo " 3 - Delete a file "
					echo " 4 - List all files in the repository"
					echo " 5 - View recent updates "
					echo " 0 - Exit "
					read entry2
					echo
					case $entry2 in
						1 ) read -p "Enter a name of a file: " fname
							while [ -e $fname ]
							do 
								echo "A file with such a name already exists"
								read -p "Enter a new name: " fname
							done
								touch  $fname
								echo " '$fname' file created in $entry" >> log.txt
							;;
						2 ) read -p "Enter a name of a file to be edited " editFile
							if [ -e $editFile ]
							then
								echo "'$editFile ' file was edited " >> log.txt
								nano $editFile
							else 
								echo "File not found "
							fi
							;;
						3 ) read -p "Enter a name of a file to be deleted " deleteFile
							if [ -e $deleteFile ]
							then
								echo "$deleteFile file was deleted " >> log.txt
								rm -f $deleteFile
							else 
								echo "File not found "
							fi
							;;
						4 ) ls -1
							;;
						5 ) less log.txt	
							;;
						0 ) cd ..
							break
							;;
						* ) echo "Invalid input"
							entry2=1;	
							;;
					esac
				done
			fi
			;;
		2 ) ls -d */ -1
			while [ $entry3 -ne 0 ]
			do
				echo " 1 - Go to the repository "
				echo " 0 - Exit"
				read entry3
				case $entry3 in
					1 ) read -p "Enter the name of a repository that you want to go to " rname
						until [ -d $rname ]
						do
							read -p "Repository not found. Enter again: " rname
						done
						cd $rname
						while [ $entry4 -ne 0 ]
						do
							echo
							echo " 1 - Add a new file to a repository"
							echo " 2 - Edit a file "
							echo " 3 - Delete a file "
							echo " 4 - List all files in the repository"
							echo " 5 - View recent updates "
							echo " 0 - Exit "
							read entry2
							echo
							case $entry2 in
								1 ) read -p "Enter a name of a file: " fname
									while [ -e $fname ]
									do 
										echo "A file with such a name already exists"
										read -p "Enter a new name: " fname
									done
										touch  $fname
										echo " '$fname' file created in $entry" >> log.txt
										;;
								2 ) read -p "Enter a name of a file to be edited " editFile
									if [ -e $editFile ]
									then
										echo "'$editFile ' file was edited " >> log.txt
										nano $editFile
									else 
										echo "File not found "
									fi
										;;
								3 ) read -p "Enter a name of a file to be deleted " deleteFile
									if [ -e $deleteFile ]
									then
										echo "$deleteFile file was deleted " >> log.txt
										rm -f $deleteFile
									else 
										echo "File not found "
									fi
										;;
								4 ) ls -1
										;;
								5 ) less log.txt	
										;;
								0 ) cd ..
									break
										;;
								* ) echo "Invalid input"
									entry2=1
										;;
							esac
						done
						;;
					0 ) break
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