


runApp() {
    docker run --rm -i --init --name=opendlv-vehicle-view -v $PWD:/opt/vehicle-view/recordings -v /var/run/docker.sock:/var/run/docker.sock -p 8081:8081 chrberger/opendlv-vehicle-view:v0.0.64
}




# STEP 1: Run the application as a docker container

runApp


# STEP 2: Navigate to the download page and download the .rec file's data as a CSV


# STEP 3: Install gnuplot, open the .csv file and visualize the data (https://alvinalexander.com/technology/gnuplot-charts-graphs-examples/)

# STEP 4: Inspect output (submission.pdf)