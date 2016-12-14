#! /bin/bash

# Download and process the Medicare data.
./load_medicare_data.sh

# Download the Yelp data.
python3.4 yelp_pull.py

#Download the Hospital Safety Score data.


# Merge the data sets.


# Load the master data set into Hive and run the server.
./master.sh
