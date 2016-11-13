#! /bin/bash

# Download the data.
mkdir data
cat > .gitignore <<EOF
data/
EOF

cd data
wget -O hospital_compare.zip https://data.medicare.gov/views/bg9k-emty/files/a24d7358-cadb-4d3e-bebc-ecf41e8a74b9?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_FlatFiles.zip
wget -O payment.csv  https://data.cms.gov/api/views/97k6-zzx3/rows.csv?accessType=DOWNLOAD

# Create a directory in HDFS to put the files.
hdfs dfs -mkdir /user/w205/data

# Unzip the file.
unzip -uo  hospital_compare.zip

# Replace spaces in names with underscores.
for f in *\ *; do mv "$f" "${f// /_}"; done

# Load the files into HDFS.
hdfs dfs -put *.csv /user/w205/data

