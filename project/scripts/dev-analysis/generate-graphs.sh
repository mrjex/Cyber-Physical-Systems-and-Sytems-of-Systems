# This line is only necessary for WSL2?
# sudo chmod 0700  /run/user/1000/


for i in {1..5}
do


# --------- Execute "single-graph.sh" and "multi-graph.sh" with specified arguments to generate the corresponding graph of a CSV file ----------



# --- REQUESTS ---


# GROUNDSTEERING
./single-graph.sh opendlv.proxy.GroundSteeringRequest-0 groundSteering 1584543153 1584543233 -1 1 groundSteering $i

# PEDAL POSITION
./single-graph.sh opendlv.proxy.PedalPositionRequest-0 position 1584543153 1584543233 0 0.2 pedalPosition $i




# --- READINGS ---


# DISTANCE READING 1
./single-graph.sh opendlv.proxy.DistanceReading-0 distance 1584543153 1584543233 0 5 distance1 $i

# DISTANCE READING 2
./single-graph.sh opendlv.proxy.DistanceReading-2 distance 1584543153 1584543233 0 5 distance2 $i

# VOLTAGE READING 1
./single-graph.sh opendlv.proxy.VoltageReading-1 voltage 1584543153 1584543233 0 0.3 voltage1 $i

# VOLTAGE READING 3
./single-graph.sh opendlv.proxy.VoltageReading-3 voltage 1584543153 1584543233 0 0.03 voltage3 $i

# VOLTAGE READING 99
./single-graph.sh opendlv.proxy.VoltageReading-99 voltage 1584543153 1584543232 0 10 voltage99 $i

# MAGNETIC FIELD READING
./multi-graph.sh opendlv.proxy.MagneticFieldReading-0 magneticFieldX bf000a magneticFieldY fdd503 magneticFieldZ 55db1a 1584543153 1584543233 -500 500 magneticField $i

# ANGULAR VELOCITY READING
./multi-graph.sh opendlv.proxy.AngularVelocityReading-0 angularVelocityX bf000a angularVelocityY fdd503 angularVelocityZ 55db1a 1584543153 1584543233 -150 150 angularVelocity $i

# ACCELRATION READING
./multi-graph.sh opendlv.proxy.AccelerationReading-0 accelerationX bf000a accelerationY fdd503 accelerationZ 55db1a 1584543153 1584543233 -35 35 accelerationReading $i


done