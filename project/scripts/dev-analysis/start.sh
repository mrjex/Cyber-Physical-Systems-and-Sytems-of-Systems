OUTPUT_PATH="./generated-csvs/video"

# Remove all pre-existing CSV files
sudo rm -rf generated-csvs/*/opendlv.*

# Remove all pre-existing PNG files
sudo rm -rf generated-pngs/*/*.png


############     STEP 1 - GENERATE CSVS     ############

for i in {1..5}
do

CURRENT_VIDEO=${i} docker compose up

sudo rm -rf opendlv.proxy.ImageReading-0
sudo mv opendlv.* "${OUTPUT_PATH}${i}"

done


############     STEP 2 - GENERATE PNGS     ############

sudo chmod +x generate-graphs.sh
sudo chmod +x single-graph.sh
sudo chmod +x multi-graph.sh

./generate-graphs.sh