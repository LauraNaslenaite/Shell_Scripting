#!/usr/bin/bash 

num=1
newFile=Y


display_submenu ()
{
	echo
	echo " 1 - Add a new file to a repository"
	echo " 2 - Edit a file "
	echo " 3 - Delete a file "
	echo " 4 - List all files in the repository"
	echo " 5 - View recent updates "
	echo " 6 - Undo latest changes made to a file "
	echo " 0 - Back "
	echo "-------------------------------------"
}

delete_a_repo()
{
		directory=$(pwd)
		echo "List of repositories in the directory ${directory}: "
		ls -d */
		echo
		read -p "Enter the name of the repository that you would like to delete: " entry
		echo

		until [ -d $entry ] 2> invalid_input.log
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

			finalDirectory="${directory}/${entry}"
			echo "Directory ${finalDirectory} has been deleted."
			echo "'$entry' repository deleted" >> ${directory}/updates.log
			echo
			rm -rf $finalDirectory
		fi

		return 1
}

delete_all_repos()
{

	read -p "Are you sure you want to delete all repositories? This action is perminant. Please double check. | 1 = Yes | 2 = No |" deletevalidation
	while [[ "$deletevalidation" != "1" && "$deletevalidation" != "2" ]]
		do
			echo "Response Invalid!"
			read -p "| 1 = Yes | 2 = No |" deletevalidation
			echo
		done

	if [ $deletevalidation == 1 ]
			then
			
	directory=$(pwd)
				echo "All directories have been deleted."
				find . \! -name 'shell.sh' -delete
			fi

			return 1

}

compile_c_program()
{
	pwd
	ls -d */
	echo
	read -p "Enter the name of a repository: " cDir
	echo

	until [ -d $cDir ]
	do
		pwd
		read -p "Repository not found. Enter again: " cDir
		echo
	done

	cd $cDir
	ls

	echo
	read -p "Enter the name of a C file (.c): " cFile
	echo


	while [[ $cFile != *.c ]]
	do
		read -p "C File not found. Enter again: " cFile
		echo

	done


	gcc $cFile
	chmod 777 $cFile
	./a.out
	cd ..
	echo
	echo
	return 1
}

compress_folder()
{
	directory=$(pwd)
	pwd
	ls -d */ 
	echo
	read -p "Enter the name of a repository you would like to compress: " dirName
	echo

	until [ -d $dirName ]
	do
		pwd
		read -p "Repository not found. Enter again: " dirName
		echo
	done

	read -p "What method would you like? 1 = zip, 2 = tar.gz: " compresssionChoice

	while [[ "$compresssionChoice" != "1" && "$compresssionChoice" != "2" ]]
	do
		echo "That is not a valid response."
		read -p "Enter 1 for YES or 2 for NO: " compresssionChoice
		echo
		
	done

	if [ $compresssionChoice == 1 ]
		then 
				zip -r $dirName.zip $dirName
				echo "$dirName has been zipped!"
				echo "'$dirName' has been zipped." >> ${directory}/updates.log
				echo >> ${directory}/updates.log

				echo

		else [ $compresssionChoice == 2 ]
			tar -czvf $dirName.tar.gz $dirName
			echo "$dirName has been compressed with tar!"
			echo "'$dirName' has been compressed with tar." >> ${directory}/updates.log
			echo >> ${directory}/updates.log
			echo
		fi

	echo
	return 1
}

#check out - make a copy of an exisiting file and make changes on a copy
#check in - updating original file version with changes made in the copy 
edit_a_file ()
{
	cp $1 copy
	nano copy

	echo
	echo "Changes made: "
	diff -u $1 copy | tee patchfile.patch
	echo
	read -p "Do you want to save changes to the '$1' file? 1 = YES, 2 = NO: " save_entry

	while [[ "$save_entry" != "1" && "$save_entry" != "2" ]]
	do
		echo "Invalid input"
		read -p "ENTER 1 for YES or 2 for NO: " save_entry
	done

	if [ $save_entry == 1 ]
	then
		echo
		patch -b $1 patchfile.patch >> updates.log
		echo "$USER made changes to '$1' file $(date)" >> updates.log
		comment_entry=1
		while [ $comment_entry -ne 2 ]
		do
			read -p "File was edited. Please, comment your changes. 1 = YES, 2 = NO: " comment_entry
			case $comment_entry in
				1 ) echo "Your comments (to stop press CTR+D) : "
					comments=$(</dev/stdin)
					echo "	Comments:" >> updates.log
					echo "	"$comments"" >> updates.log
					echo >> updates.log
					comment_entry=2
					;;
				2 ) break;
					;;
				* ) echo "Invalid input."
					comment_entry=1
					;;
			esac
		done
	fi
	rm -f copy
	rm -f patchfile.patch
	echo
}

restore ()
{
	ls *orig 2> error.log  
	if [ -s error.log ] 
	then
	echo "No backup versions of files created"

	else 
		echo
		read -p "Choose a file that you want to restore to its previous version: " restore_file

		until [ -e $restore_file ]
		do
			read -p "Invalid input. Enter file name from the list: " restore_file
		done

		file_name=${restore_file%.*}
		cp $restore_file $file_name
		rm -f $restore_file

		echo "'$file_name' file was restored by $USER" | tee -a updates.log
		echo >> updates.log

	fi
	echo
}

add_a_new_file ()
{
	read -p "Enter a name for a file: " fname
	while [ -e $fname ] #repeat the loop until the name of a file is not found in rep
	do 
		echo "A file with such a name already exists"
		read -p "Enter a new name: " fname
	done
	touch  $fname
	echo "'$fname' file created in the repository" >> updates.log
	echo >> updates.log
	echo
}

delete_a_file ()
{
	if [ "$(ls -A $(pwd))" ] 
			then
                local project_files1=$(ls -I "*.log")  #storing a list of project files (excluding logs) in a variable
				if [ -z $project_files1 ]  2> error.log  #checking if a variable is empty. If it is empty - no file projects in rep.
                then 
                    echo "Not possible to delete. All files are already deleted."
                else
                    ls -I "*.log" -1
					echo
                    read -p "Enter a name of a file to be deleted: " deleteFile
                    until [ -e $deleteFile ]
                    do
                        echo "File not found "
                        ls -I "*.log"
                        read -p "Enter a name of file that exists: " deleteFile
                    done 
                        echo "'$deleteFile' file was deleted " >> updates.log
						echo >> updates.log
                        rm -f $deleteFile
                fi
			else 
				echo "Not possible to delete a file. No files in the repository "
			fi	
		echo
}

list_files_in_repo ()
{
	if [ "$(ls -A $(pwd))" ] 
	then
				echo "*Project Files* "
				ls -I "*.log" -1
				echo
				echo "*Other Files* "
				ls -1 *.log

				view=1
                while [ $view -ne 2 ] 
                do
					echo
					echo "View content of a chosen file"
                    echo "1 - Yes "
                    echo "2 - No"
                    echo "------------------------------"
                    read view 2> invalid_input.log
					echo
                    case $view in
                        1 ) ls -1
							echo
							read -p "Enter a file name : " view_fname
                                until [ -e $view_fname ]  #repeat the loop until the name of a file is found in rep
                    			do
                        			echo "File was not found "
                        			read -p "Enter a name of file that exists: " view_fname
                    			done 
								less $view_fname
                                ;;
                        2 ) break
                                ;;
                        * ) echo "Invalid input"
                            view=1
                                ;;
                    esac
                done
			else 
				echo "Repository is empty "
			fi	
		echo
			
}

actions_in_repo ()
{
	local entry4=11 #random number
	while [ $entry4 -ne 0 ] #while not to exit the loop
		do
			echo
			ls -1 -I "*.log"
			display_submenu
			read entry4 2> invalid_input.log
			echo
		case $entry4 in
		1 ) add_a_new_file
			echo
			;;
		2 )	if [ "$(ls -A $(pwd))" ]  
			then
				local project_files=$(ls -I "*.log")  #storing a list of project files (excluding logs) in a variable
				if [ -z $project_files ]  2> error.log #checking if a variable is empty. If it is empty - no file projects in rep.
                then 
                    echo "Not possible to edit. All files were deleted."
                else
                    ls -I "*.log" -I "*.orig"
					echo
                    read -p "Enter a name of a file to be edited " editFile
                    until [ -e $editFile ]  #repeat the loop until the name of a file is found in rep
                    do
                        echo "File not found "
                        read -p "Enter a name of file that exists: " editFile

                    done 
                       edit_a_file $editFile
                fi
			else 
				echo "No files to edit."
			fi	
			echo
			;;
		3 ) delete_a_file	
			echo
				;;
		4 ) list_files_in_repo
			echo
			;;
		5 ) if [ -e updates.log ]
			then
				less updates.log
			else 
				echo "No updates meaning no files created in the repository "
			fi	
			echo
			;;
		6 ) restore
			echo
			;;

		0 ) cd ..
			echo
			break
			;;
		* ) echo "Invalid input"
			entry4=1
			echo
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
	echo " 4 - DELETE ALL REPOSITORIES"
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
				echo >> updates.log
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
								echo >> updates.log
                                ((number_of_files++))
								echo
                                ;;
                        n|N ) cd ..
								echo
                                break
                                ;;
                        * ) echo "Invalid input"
                            newFile=Y
							echo
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
				echo
				echo "------------------------------"
				echo " 1 - Go to the repository "
				echo " 2 - Delete a repository "
				echo " 3 - Compile a C program"
				echo " 4 - Compress a repository"
				echo " 0 - Back"
				echo "------------------------------"
				read entry3 2> invalid_input.log
				case $entry3 in
					1 ) echo
						ls -d */ -1
						echo
						read -p "Enter the name of a repository that you want to go to: " rname 
						until [ -d $rname ] 2> invalid_input.log
						do
							read -p "Repository not found. Enter again: " rname
						done
						cd $rname
						actions_in_repo
						echo
						ls -d */
						;;
					2 )	echo
						delete_a_repo
						echo
						ls -d */
						;;	
					3 ) echo
						compile_c_program
						echo
						ls -d */
						;;

					4 ) echo
						compress_folder
						echo
						ls -d */
						;;
					0 ) echo
						break
						;;
					* ) echo
						echo "Invalid input"
						echo
						entry3=1
						ls -d */
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
			echo
			;;
		4 ) delete_all_repos
			;;
		0 ) break 
			echo
			;;
		* ) echo "Invalid input"
			echo
			num=1  #setting a variabe to be have a valid value so that the while loop could run at least once again
			;;
	esac
done