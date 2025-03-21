###  ARGUMENTS ###
# arg 1: csv file name
# arg 2: attribute column (y value 1): Name
# arg 3: attribute column (y value 1): Line color
# arg 4: attribute column (y value 2): Name
# arg 5: attribute column (y value 2): Line color
# arg 6: attribute column (y value 3): Name
# arg 7: attribute column (y value 3): Line color

# arg 8: min value of 'sent.seconds' in the csv file
# arg 9: max value of 'sent.seconds' in the csv file
# arg 10: min value of all y-value-lines [arg2, arg4, arg6]
# arg 11: max value of all y-value-lines [arg2, arg4, arg6]
# arg 12: Output png file name
# arg 13: Video folder name (1-5)

source ../csv-parser.sh

CSV_OUTPUT_PATH="./generated-csvs/video${13}/$1"
PNG_OUTPUT_PATH="./generated-pngs/video${13}/${12}"

xStart=$(getFirstRow "${CSV_OUTPUT_PATH}")
xEnd=$(getLastRow "${CSV_OUTPUT_PATH}")

gnuplot <<EOF
set datafile separator ';'
# set terminal png size 1500 1200

plot '${CSV_OUTPUT_PATH}.csv' using 1:7 title "$2" lc rgb "#$3" lw 2 w lp, \
     '${CSV_OUTPUT_PATH}.csv' using 1:8 title "$4" lc rgb "#$5" lw 2 w lp, \
     '${CSV_OUTPUT_PATH}.csv' using 1:9 title "$6" lc rgb "#$7" lw 2 w lp
set title 'Data Visualization'
set xlabel 'timeStamp (Microseconds)'
set ylabel 'Y-Value'
set xrange [${xStart}:${xEnd}]
set yrange [${10}:${11}]
set grid

set term png size 1200, 720
set output '${PNG_OUTPUT_PATH}.png'
replot
EOF