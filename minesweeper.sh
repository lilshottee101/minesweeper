#!/usr/bin/env bash

COLS=$(tput cols)
LINS=$(tput lines)
LINES=$((LINS - 2))


declare -A colourArray valueMatrix
declare mineMultiplier
colourArray=([1]="\e[38;5;21m"
	     [2]="\e[38;5;34m"
	     [3]="\e[38;5;196m"
	     [4]="\e[38;5;19m"
	     [5]="\e[38;5;88m"
	     [6]="\e[38;5;30m"
	     [7]="\e[38;5;16m"
	     [8]="\e[38;5;235m"
	     [hidden]="\e[48;5;240m"
	     [visible]="\e[48;5;250m")


bottomText="Use 'WASD' to move around, 'F' to flag a bombs location, 'E' to reveal."
topText="MINESWEEPER"

bottomTextLength=${#bottomText}
topTextLength=${#topText}
generateMatrix() {
	for (( i=1; i<$LINES; i++ )) do
		for (( y=1; y<$COLS; y++ )) do
			num=$((RANDOM % 100))
			if [ $num -le $1 ]; then
				valueMatrix[$i,$y]="X"
			else
				valueMatrix[$i,$y]="O"
			fi
		done
	done

	for (( x=1; x < $LINES; x++ )) do
		for (( y=1; y < $COLS; y++ )) do
			mineCount=0
			if [ "${valueMatrix[$x,$y]}" != "X" ]; then
				for (( mx=$x - 1; mx <= $x + 1; mx++ )) do
					for (( my=$y - 1; my <= $y + 1; my++ )) do
						if [[ "${valueMatrix[$mx,$my]}" == "X" ]]; then
							((mineCount++))
						fi
					done
				done
				valueMatrix[$x,$y]="$mineCount"
			fi
		done
	done
}
printMatrix() {
	for (( x=1; x < $LINES; x++ )) do
		for (( y=1; y < $COLS; y++ )) do
			goto $((x + 1)) $y	
			printf "${valueMatrix[$x,$y]}"
		done
	done
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
	read -p "Please select difficulty: \n 1) Easy \n 2) Medium \n 3) Hard \n :" difficulty
	case $difficulty in
		"1" | "Easy" | "easy")
			generateMatrix 12
		;;
		"2" | "Medium" | "medium")
			generateMatrix 15
		;;
		"3" | "Hard" | "hard")
			generateMatrix 20
		;;
	esac
	clear
	printMatrix
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
