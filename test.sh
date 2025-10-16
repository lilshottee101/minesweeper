#!/usr/bin/env bash
declare -A valueMatrix
COLS=$(tput cols)
LINS=$(tput lines)
LINES=$((LINS - 2))
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
generateMatrix 20
echo "${valueMatrix[@]}"
