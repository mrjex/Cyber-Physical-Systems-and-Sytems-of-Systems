
source ../scripts/csv-parser.sh
videoDenotation="video"

for i in {1..5}
do
    currentOutput="video$i"

    VID_NR=${i} docker compose up --abort-on-container-exit



    # firstRow=$(sort -n -k 1 ../Generated_CSV/${currentOutput}.csv | head -n 2)
    # lastRows=$(sort -r -k 1 ../Generated_CSV/${currentOutput}.csv | head -n 2)

    # arrSplit=(${firstRow//;/ })
    # xStart=${arrSplit[3]}

    # arrSplit2=(${lastRows//;/ })
    # xEnd=${arrSplit2[3]}


    
    xStart=$(getFirstRow "../Generated_CSV/${currentOutput}")
    xEnd=$(getLastRow "../Generated_CSV/${currentOutput}")



    curl --location --header "PRIVATE-TOKEN: ${ARTIFACT_TOKEN}" "https://git.chalmers.se/api/v4/projects/${CI_PROJECT_ID}/jobs/artifacts/${CI_COMMIT_BRANCH}/raw/graphs-output/video${i}.csv?job=plotgraph" --output ../prev-${i}.csv

gnuplot <<EOF
set datafile separator ';'
set terminal png size 1500 1200

plot '../Generated_CSV/${currentOutput}.csv' using 1:2 title "correct-groundSteering" lc rgb "#00ff00" lw 2 w lp, \
     '../Generated_CSV/${currentOutput}.csv' using 1:3 title "calculated-groundSteering" lc rgb "#0000ff" lw 2 w lp, \
     '../prev-${i}.csv' using 1:3 title "previous-groundSteering" lc rgb "#ff0000" lw 2 w lp

set title 'graph${i}'
set xlabel 'sampleTime (Microseconds)'
set ylabel 'groundSteering'
set xrange [${xStart}:${xEnd}]
set yrange [-0.3:0.3]
set grid

set term png size 1200, 720
set output '${currentOutput}.png'
replot

EOF
done

# move the generated csvs to the artifacts
mv ../Generated_CSV/* .