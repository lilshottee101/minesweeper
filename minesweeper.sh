#!/usr/bin/env bash

COLS=$(tput cols)
LINS=$(tput lines)


declare -A matrix


bottomText="Use 'WASD' to move around, 'F' to flag a bombs location, 'E' to reveal."
topText="MINESWEEPER"

bottomTextLength=${#bottomText}
topTextLength=${#topText}
checkSet() {
		# Pass in 3 args, value1, value2 and variable to set.	
		if [ $1 -gt $2 ]; then
			$3 = $2
		else
			$3 = $1
		fi
}
setup() {
	read -p "Please select difficulty: \n 1) Easy \n 2) Medium \n 3) Hard \n :" difficulty
	read -p "Please select maze size: \n 1) Beginner \n 2) Intermediate \n 3) Expert \n 4) Terminal Size \n 5) Custom (Max Terminal Size) \n :" boardSize
	case $boardSize in
		"1" | "Beginner" | "beginner")
			boardHeight=9
			boardWidth=9
		;;
		"2" | "Intermediate" | "intermediate")
			checkSet "30" $COLS $boardWidth
			checkSet "30" $LINS $boardHeight
		;;
		"3" | "Expert" | "expert")
			boardHeight=30
			boardHeight=30
		;;
	esac
	if [[ -n $1 || -n $2 ]]; then
		if [ $1 -gt $COLS ]; then
			$mazeWidth=$COLS
		else
			$mazeWidth=$1
		fi
		if [ $1 -gt $LINS ]; then
			$mazeHeight=$LINS
		else
			$mazeHeight=$2
		fi
	fi
}
# Accepts arguments as Line Column Text
goto() {
	#Goes to line and colunm then prints	
	printf "\e[${1};${2}H"
}

#CleanUp Function
cleanUp() {
	clear
	exit 0
}
# Main function that sets up loop and then runs function to listen for keybinds
main() {
	setup
	printf "\e[?47h"
	printf "\e 7"
	clear
	#Prit Instructions to the bottom of the screen
	goto $LINS $(((COLS / 2) - (bottomTextLength / 2)))
	printf "$bottomText"
	#Print Title to the top of the screen
	goto 1 $((COLS / 2 - (topTextLength / 2))) 
	printf "$topText"

	goto $((LINS / 2)) $((COLS / 2))
	
	while [ true = true ]; do
		read -sn 1 uInput
		case $uInput in
			"w" | "k" | "[A")
				printf "\e[1A"	
			;;

			"s")
				printf "\e[1B"	
			;;

			"d")
				printf "\e[1C"	
			;;

			"a")
				printf "\e[1D"	
			;;
			"f")
				printf "\u8226"
			;;
			esac
	done
}

trap cleanUp SIGINT
echo "$boardHeight $boardWidth"
main
