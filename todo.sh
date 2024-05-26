#!/bin/bash

arg=$1

[ ! -f "tasks.txt" ] && touch tasks.txt

createTask(){
	echo "-------------------------------------------------------------------"
	echo "                   Let's creat a tasks !!!!!!                      "
	echo "-------------------------------------------------------------------"

	if [ -z tasks.txt ]
	then
		identifier=1
	else
		dernierId=$(tail -1 tasks.txt | cut -d "|" -f 1)
		identifier=$((dernierId+1))
	fi
	while true; do
		echo "Enter the tasks title(required):" 
		read title
		if [ -z "$title" ]
		then
			echo "The tasks title is required" >&2
		else
			break
		fi
	done

	echo "Enter the tasks description"
	read description
	if [ -z "$description" ]
	then
		description="no description"
	fi
	
	echo "Enter the tasks location"
	read location
	if [ -z "$location" ]
	then
		location="no location"
	fi

	today=$(date +%Y-%m-%d)
	echo "Enter the tasks due date format YYYY-MM-DD (required):" 
	while true; do
		read dateD
		if [ -z "$dateD" ]
		then
			echo "The tasks due date is required" >&2
		elif [[ ! "$dateD" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
		then
			echo "incorrect format please use this format YYYY-MM-DD" >&2
		elif [ $(date -d "$dateD" +%s) -lt $(date -d "$today" +%s) ]
		then
			echo "Date dépasée !! Please entrer a valid date and use this format YYYY-MM-DD :"
		else
			break
		fi
	done
	echo "$identifier | $title | $description | $location | $dateD | uncompleted" >> tasks.txt

}

updateTask(){
	
	echo "-------------------------------------------------------------------"
	echo "                 These are your tasks !!!!!!                       "
	echo "-------------------------------------------------------------------"
	cat tasks.txt
	echo "-------------------------------------------------------------------"
	echo "Enter the id of the task you want to update: "
	while true; do
	read idUp
	if grep -q "^$idUp" tasks.txt 
	then
		while true; do
			echo "Which field you want to update ? "
			echo "Enter 1 for: Title "
			echo "Enter 2 for: Description"
			echo "Enter 3 for: Location"
			echo "Enter 4 for: Due Date"
			echo "Enter 5 for: Completion marker"
			read choice
			if [[ ! "$choice" =~ ^[1-5]$ ]]
			then
				echo "Invalide choice !! " >&2
			else 
				break
			fi
		done
		case "$choice" in
			"1")
				while true; do
					echo "Enter the new tasks title(required):" 
					read title
					if [ -z "$title" ]
					then
						echo "The tasks title is required" >&2
					else
						break
					fi
				done
				awk -F '|' -v OFS='|' -v id="$idUp" -v title=" $title " '$1 == id {$2=title; print} !($1 == id)' tasks.txt > temp.txt && mv temp.txt tasks.txt

			;;
			"2")
				echo "Enter the new tasks description"
				read description
				if [ -z "$description" ]
				then	
					description="no description"
				fi
				awk -F '|' -v OFS='|' -v id="$idUp" -v description=" $description " '$1 == id {$3=description; print} !($1 == id)' tasks.txt > temp.txt && mv temp.txt tasks.txt
			
			;;
			"3")	
				echo "Enter the new tasks location"
				read location
				if [ -z "$location" ]
				then
					location="no location"
				fi
				awk -F '|' -v OFS='|' -v id="$idUp" -v location=" $location " '$1 == id {$4=location; print} !($1 == id)' tasks.txt > temp.txt && mv temp.txt tasks.txt

			;;
			"4")
				today=$(date +%Y-%m-%d)
				echo "Enter the new tasks due date format YYYY-MM-DD (required):" 
				while true; do
					read dateD
					if [ -z "$dateD" ]
					then
						echo "The tasks due date is required" >&2
					elif [[ ! "$dateD" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
					then
						echo "incorrect format please use this format YYYY-MM-DD: " >&2
					elif [ $(date -d "$dateD" +%s) -lt $(date -d "$today" +%s) ]
					then
						echo "Date dépasée !! Please entrer a valid date and use this format YYYY-MM-DD :"
					else
						break
					fi
				done
				awk -F '|' -v OFS='|' -v id="$idUp" -v dateD=" $dateD " '$1 == id {$5=dateD; print} !($1 == id)' tasks.txt > temp.txt && mv temp.txt tasks.txt
			;;
			"5")	
				echo "Is the task completed (enter 0 for: yes / enter 1 for: no):"
				read completed
				while true; do
					if [[ ! "$completed" =~ ^[0-1]$ ]]
					then
						echo "incorrect format please enter 0 for: yes / enter 1 for: no" >&2
						read completed
					else
						break
					fi
				done
			
				if [ "$completed" -eq 0 ]
				then 
					awk -F '|' -v OFS='|' -v id="$idUp" '$1 == id {$6=" completed "; print} !($1 == id)' tasks.txt > temp.txt && mv temp.txt tasks.txt
				else
					awk -F '|' -v OFS='|' -v id="$idUp" '$1 == id {$6=" uncompleted "; print} !($1 == id)' tasks.txt > temp.txt && mv temp.txt tasks.txt
				fi
			;;			
		esac

				
	break
	else
		echo "Non valid id please enter an existent id" >&2
	fi
	done
}

deleteTask(){
	
	echo "-------------------------------------------------------------------"
	echo "                 These are your tasks !!!!!!                       "
	echo "-------------------------------------------------------------------"
	cat tasks.txt
	echo "-------------------------------------------------------------------"
	echo "Enter the id of the task you want to delete: "
	while true; do
	read idUp
	if grep -q "^$idUp" tasks.txt 
	then
		sed -i "/^$idUp/d" tasks.txt
		echo "Task deleted succesfully !!!"
		break
	else
		echo "Non valid id please enter an existent id" >&2
	fi
	done
}

showInf(){
	
	echo "-------------------------------------------------------------------"
	echo "                 These are your tasks !!!!!!                       "
	echo "-------------------------------------------------------------------"
	cat tasks.txt
	echo "-------------------------------------------------------------------"
	echo "Enter the id of the task about which you want to see all information : "
	while true; do
	read idUp
	if grep -q "^$idUp" tasks.txt
	then
		echo "-------------------------------------------------------------------"
		echo "                 Thes task's information !!!!!!                       "
		echo "-------------------------------------------------------------------"
		grep "^$idUp" tasks.txt
		
		break
	else
		echo "Non valid id please enter an existent id" >&2
	fi
	done
}

listTasks(){

	day=$1

	if [ "$#" -eq 0 ]
	then
		echo "Enter the day you want to see it's tasks (YYYY-MM-DD):"
		while true; do
			read day
			if [[ ! "$day" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
			then
				echo "incorrect format please use this format YYYY-MM-DD: " >&2
			else
				break
			fi
			
		done
	fi
	
	if grep -q "^[^|]*|[^|]*|[^|]*|[^|]*| *$day *|" tasks.txt 
	then
		echo "-------------------------------------------------------------------"
		echo "                         completed tasks                           "
		echo "-------------------------------------------------------------------"
		sed -n "/^[^|]*|[^|]*|[^|]*|[^|]*| *$day *| *completed */p" tasks.txt	
		echo "-------------------------------------------------------------------"
		echo "                        uncompleted tasks                           "
		echo "-------------------------------------------------------------------"
		sed -n "/^[^|]*|[^|]*|[^|]*|[^|]*| *$day *| *uncompleted */p" tasks.txt	
	else
		echo "-------------------------------------------------------------------"
		echo "                    No tasks for that day !!!                      "
		echo "-------------------------------------------------------------------"
	fi

}
searchTask(){
	
	echo "-------------------------------------------------------------------"
	echo "                 These are your tasks !!!!!!                       "
	echo "-------------------------------------------------------------------"
	cat tasks.txt
	echo "-------------------------------------------------------------------"
	echo "Enter the title of the task you want to search for : "
	read title
	if grep -q "^[^|]*| *$title *|" tasks.txt 
	then
		echo "-------------------------------------------------------------------"
		echo "                 This task exists !!!!!!                       "
		echo "-------------------------------------------------------------------"
		echo "These are this task's information:"
		sed -n "/^[^|]*| *$title *|/p" tasks.txt
	else
		echo "This title doesn't exist" >&2
	fi
	
}
case "$arg" in 
	"createTask")
		createTask
	;;
	"updateTask")
		updateTask
	;;
	"deleteTask")
		deleteTask
	;;
	"showInf")
		showInf
	;;
	"listTasks")
		listTasks
	;;
	"searchTask")
		searchTask
	;;
	"")
		current_day=$(date +%F)
		listTasks "$current_day"
	;;
	*)
		echo "-------------------------------------------------------------------"
		echo "          Invalide argument !!! Put as argument:"
		echo "-------------------------------------------------------------------"
		echo ""
		echo "createTask   to: Create a task."
		echo "updateTask   to: Update a task."
		echo "deleteTask   to: Delete a task."
		echo "showInf      to: Show all information about a task."
		echo "listTasks    to: List tasks of a given day."
		echo "searchTask   to: Search for a task by title."
		echo ""
	;;
esac