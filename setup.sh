#! /bin/bash

# Download and process the Medicare data.
./load_medicare_data.sh

# Download the Yelp data.
python3.4 yelp_pull.py

#Download the Hospital Safety Score data.
python3 Hospital_Safety_Grade.py

# Merge the data sets.
python3 data_merge.py

# Load the master data set into Hive and run the server.
./master.sh
