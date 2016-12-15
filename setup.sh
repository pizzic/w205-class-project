#! /bin/bash

# Download and process the Medicare data.
./load_medicare_data.sh

# Download the Yelp data.
python3.4 yelp_pull.py

# Download the Hospital Safety Score data.
# Have to do this in multiple parts because the script can't do all the states at once.
python3 Hospital_Safety_Grade.py 1
python3 Hospital_Safety_Grade.py 2
python3 Hospital_Safety_Grade.py 3
python3 Hospital_Safety_Grade.py 4
python3 Hospital_Safety_Grade.py 5

# Merge the data sets.
python3 data_merge.py

# Load the master data set into Hive and run the server.
./master.sh
