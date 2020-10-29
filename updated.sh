#!/usr/bin/bash

num=1
newFile=Y

delete_a_repo()
{
		pwd
		ls
		echo
		read -p "Enter the name of the repository that you would like to delete: " entry
		echo

		until [ -d $entry ]
		do
			read -p "Repository not found. Enter again: " entry
			echo
		done

		read -p "Are you sure you would like to delete $entry? This can't be undone. 1 = YES, 2 = NO: " entrySure
		echo

		while [[ "$entrySure" != "1" && "$entrySure" != "2" ]]
		do
			echo "That is not a vaild response."
			read -p "Enter 1 for YES or 2 for NO: " entrySure
			echo
		done

		if [ $entrySure == 1 ]
		then

			directory=$(pwd)
			finalDirectory="${directory}/${entry}"
			echo "Directory ${finalDirectory} has been deleted."
			echo
			rm -rf $finalDirectory
		fi

		return 1
}

display_submenu ()
{
	echo
	echo " 1 - Add a new file to a repository"
	echo " 2 - Edit a file "
	echo " 3 - Delete a file "
	echo " 4 - List all files in the repository"
	echo " 5 - View recent updates "
	echo " 0 - Exit "
	echo "-------------------------------------"
}

actions_in_repo ()
{
	local entry4=11 #random number
	while [ $entry4 -ne 0 ] #while not to exit the loop
	do
		display_submenu
		read entry4 2> invalid_input.log
		echo
		case $entry4 in
		1 ) read -p "Enter a name for a file: " fname
			while [ -e $fname ] #repeat the loop until the name of a file is not found in rep
			do 
				echo "A file with such a name already exists"
				read -p "Enter a new name: " fname
			done
			touch  $fname
			echo " '$fname' file created in the repository" >> updates.log
			;;
		2 ) if [ -e updates.log ] # if updates.log file exists in the rep, it means that there are/were some files created
			then
				local project_files=$(ls -I "*.log")  #storing a list of project files (excluding logs) in a variable
				if [ -z $project_files ]  2> error.log #checking if a variable is empty. If it is empty - no file projects in rep.
				then 
                    			echo "Not possible to edit. All files were deleted."
                		else
                    			ls -I "*.log"
                    			read -p "Enter a name of a file to be edited " editFile
                    			until [ -e $editFile ]  #repeat the loop until the name of a file is found in rep
                    			do
                        			echo "File not found "
                        			read -p "Enter a name of file that exists: " editFile

                    			done 
                       			echo "'$editFile ' file was edited " >> updates.log
                       			nano $editFile
               			fi
			else 
				echo "Not possible to edit. No files in the repository "
			fi	
			;;
		3 ) if [ -e updates.log ] 
			then
                		local project_files1=$(ls -I "*.log")  #storing a list of project files (excluding logs) in a variable
				if [ -z $project_files1 ]  2> error.log  #checking if a variable is empty. If it is empty - no file projects in rep.
               			then 
                   			echo "Not possible to delete. All files are already deleted."
                		else
                    			ls -I "*.log"
                    			read -p "Enter a name of a file to be deleted " deleteFile
                    			until [ -e $deleteFile ]
                    			do
                        			echo "File not found "
                        			ls -I "*.log"
                        			read -p "Enter a name of file that exists: " deleteFile
                    			done 
                        		echo "$deleteFile file was deleted " >> updates.log
                        		rm -f $deleteFile
               			fi
			else 
				echo "Not possible to delete a file. No files in the repository "
			fi	
			;;
		4 ) if [ -e updates.log ] 
			then
				ls -1 
			else 
				echo "Repository is empty "
			fi	
			;;
		5 ) if [ -e updates.log ]
			then
				less updates.log
			else 
				echo "No updates meaning no files created in the repository "
			fi	
			;;
		0 ) cd ..
			break
			;;
		* ) echo "Invalid input"
			entry4=1
			;;
		esac
	done
}

while [ $num -ne 0 ]
do
	echo
	echo "----------------MENU---------------- "
	echo
	echo "Choose one of the options below "
	echo " 1 - ADD A NEW REPOSITORY"
	echo " 2 - CHECK CURRENT REPOSITORIES"
	echo " 3 - RECENT UPDATES "
	echo " 0 - Exit"
	echo "-----------------------------------"
	read num 2> invalid_input.log    #if invalid input is not an integer, an error message is written to a log instead of being diplayed to a user
	echo
	case $num in
		1 ) read -p "Enter a name for a repository: " entry
            		while [[ "$entry" == *" "* ]]    #checking for invalid names for a rep, specifically containing whitespaces (e.g. 'nam e'), otherwise 2 separate repos are created
           		do                     
                		echo "Non valid repository name"
               			read -p "Enter a name for a repository: " entry
            		done

               		while [ -d $entry ]  2> invalid_input.log  
               		do 
                    		echo "A repository with such a name already exists"
                    		read -p "Enter a new name for a repository: " entry
                	done
                	mkdir $entry
                	echo "'$entry' repository created " >>  updates.log
                	cd $entry
                	echo
                	number_of_files=0
                	while [ $number_of_files -eq 0 ] 
                	do
                    		echo "Add a new file to a repository"
                    		echo "y - Yes "
                    		echo "n - No"
                    		echo "------------------------------"
                    		read newFile 2> invalid_input.log
                    		case $newFile in
                       		y|Y ) read -p "Enter a name of a file: " fname
                               		while [[ "$fname" == *" "* ]]  
                                	do                     
                                    		echo "Name cannot contain whitespaces."
                                    		read -p "Enter a name for a file: " fname
                                	done
                                	touch  $fname
                                	echo "'$fname' file created in repository" >> updates.log
                                	((number_of_files++))
                               		 ;;
                       		n|N ) cd ..
                                	break
                               		 ;;
                       		* ) echo "Invalid input"
					newFile=Y
                                	;;
                    		esac
               		 done    
                	if [ $number_of_files -eq 1 ]  #if there is at least one file added to rep
                	then
                    		actions_in_repo
			fi
			;;
		2 ) ls -d */ 2> error.log   #listing only repositories. If there are no repositories found, an error message is sent to a log rather than being displayed for a user
			if [ -s error.log ]     #checking if there are any text in log. If there is, it means that an error message was received from previous line indicating that there are no reps
			then 
				echo "No repositories created "
			else
            		entry3=1;
			while [ $entry3 -ne 0 ]
			do
				echo " 1 - Go to the repository "
				echo " 2 - Delete a repository "
				echo " 0 - Exit"
				echo "------------------------------"
				read entry3 2> invalid_input.log
				case $entry3 in
					1 ) ls -d */
						read -p "Enter the name of a repository that you want to go to " rname 
						until [ -d $rname ] 2> invalid_input.log
						do
							read -p "Repository not found. Enter again: " rname
						done
						cd $rname
						actions_in_repo
						;;

					2 ) delete_a_repo
						break
						;;	

					0 ) break
						;;
					* ) echo "Invalid input"
						entry3=1
							;;
					esac
			done
			fi
			;;
		3 ) if [ -e updates.log ]
			then
				less updates.log
			else 
				echo "No updates"
			fi	
			;;
		0 ) break 
			;;
		* ) echo "Invalid input"
			num=1  #setting a variabe to be have a valid value so that the while loop could run at least once again
			;;
	esac
done
