###  ARGUMENTS ###
# arg 1: csv file name
# arg 2: attribute column name inside the csv file (previous: 'groundSteering:')
# arg 3: min value of 'sent.seconds' in the csv file
# arg 4: max value of 'sent.seconds' in the csv file
# arg 5: min value of the [arg2] attribute
# arg 6: max value of the [arg2] attribute
# arg 7: output png name
# arg 8: Video folder name (1-5)

source ../csv-parser.sh

CSV_OUTPUT_PATH="./generated-csvs/video${8}/${1}" # prev works: .csv
PNG_OUTPUT_PATH="./generated-pngs/video$8/$7" # .png

xStart=$(getFirstRow "${CSV_OUTPUT_PATH}")
xEnd=$(getLastRow "${CSV_OUTPUT_PATH}")

gnuplot <<EOF
set datafile separator ';'

plot '${CSV_OUTPUT_PATH}.csv' using 1:7 title "$2" lc rgb '#02afd7' lw 3 w lp
set title 'Data Visualization'
set xlabel 'timeStamp (Microseconds)'
set ylabel 'Y-value'
set xrange [${xStart}:${xEnd}]
set yrange [$5:$6]
set grid

set term png size 1200, 720
set output '${PNG_OUTPUT_PATH}.png'
replot
EOF