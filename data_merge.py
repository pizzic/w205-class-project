#!/usr/bin/env python3

import glob
import os
import pandas as pd
import numpy as np

# Libraries for distance measures
import Levenshtein
from fuzzywuzzy import fuzz, StringMatcher, process
import difflib # part of standard library
import csv

# Concatenating all Hospital Safety Grade files into one dataframe
# hsg = Hospital Safety Grade
path = r''
all_files = glob.glob(os.path.join(path, "Hospital Safety Grade*.csv"))
df_from_each_file = (pd.read_csv(f, encoding = "latin1") for f in all_files)
hsg = pd.concat(df_from_each_file, ignore_index=True)

# Modifying zip code to only 5 digits
zip = hsg.apply(lambda x: x["ZipCode"][:5], axis=1)
hsg["ZipCode"] = zip

# Strip unnecessary whitespace and convert zip code to integer
hsg["Name"] = hsg["Name"].map(str.strip)
hsg["State"] = hsg["State"].map(str.strip)
hsg["ZipCode"] = hsg["ZipCode"].astype(int)

# Reading in Yelp data and removing duplicates
yelp = pd.read_csv("yelp_hospitals.csv", encoding = "latin1")
yelp = yelp.drop_duplicates(subset = ["Address", "City", "Name", "Rating", "State", "ZipCode"])

# Strip unnecessary whitespace and convert zip code to integer
yelp["Name"] = yelp["Name"].map(str.strip)
yelp["State"] = yelp["State"].map(str.strip)
yelp["ZipCode"] = yelp["ZipCode"].astype(int)

# Matching all three datasets

# Step 1: Match Hospital Safety Grade and Yelp datasets
left_join = pd.merge(hsg, yelp, on=['ZipCode'], how='left')

indices = []

for index, row in left_join.iterrows():
    if type(row['Name_x']) == str and type(row['Name_y']) == str and type(row['Address_x']) == str and type(row['Address_y']) == str:
        lev_name = Levenshtein.ratio(row['Name_x'], row['Name_y'])
        lev_addr = Levenshtein.ratio(row['Address_x'], row['Address_y'])
        if (lev_name >= 0.9 and lev_addr >= 0.6) or (lev_name >= 0.55 and lev_addr >= 0.9):
            indices.append(index)
            print(row['Name_x'], ",", row['Address_x'])
            print(row['Name_y'], ",", row['Address_y'], ",", Levenshtein.ratio(row['Name_x'], row['Name_y']), ",", Levenshtein.ratio(row['Address_x'], row['Address_y']))

for_eric = left_join.loc[indices]
for_eric = for_eric.groupby(["Name_x", "Address_x", "City_x", "State_x", "ZipCode", "Grade"]).aggregate(np.mean)
for_eric = for_eric.drop('Unnamed: 0', 1).reset_index()

# Step 2: Match Medicare dataset with Hospital Safety Grade / Yelp dataset

# Read in Medicare data
medicare_headers = ["ProviderID", "HospitalName", "Address", "City", "State", "ZipCode", "HospitalOverallRating", "MortalityNationalComparison",
"SafetyOfCareNationalComparison", "ReadmissionNationalComparison", "PatientExperienceNationalComparison", "EffectivenessOfCareNationalComparison",
"TimelinessOfCareNationalComparison", "EfficientUseOfMedicalImagingNationalComparison", "AverageEffectiveCareScore", "AverageReadmissionScore"]

medicare = pd.read_csv("medicare.csv", encoding = "latin1", header = None, names = medicare_headers)

left_join2 = pd.merge(medicare, for_eric, on=['ZipCode'], how='left')

indices = []

for index, row in left_join2.iterrows():
    if type(row['HospitalName']) == str and type(row['Name_x']) == str and type(row['Address']) == str and type(row['Address_x']) == str:
        HospitalName = row['HospitalName'].lower()
        Name_x = row['Name_x'].lower()
        Address = row['Address'].lower()
        Address_x = row['Address_x'].lower()
        lev_name = Levenshtein.ratio(HospitalName, Name_x)
        lev_addr = Levenshtein.ratio(Address, Address_x)
        if (lev_name >= 0.9 and lev_addr >= 0.6) or (lev_name >= 0.55 and lev_addr >= 0.9):
            indices.append(index)
            print(HospitalName, ",", Address)
            print(Name_x, ",", Address_x, ",", Levenshtein.ratio(HospitalName, Name_x), ",", Levenshtein.ratio(Address, Address_x))

for_eric2 = left_join2.loc[indices]
for_eric2 = for_eric2.drop(['Name_x', 'Address_x', 'City_x', 'State_x'], 1)
for_eric2 = for_eric2.rename(columns={'Grade' : 'SafetyGrade', 'Rating' : 'YelpRating'})

# Write to CSV
# for_eric2.to_csv("Master Data Set.csv", index = False)

# Match Medicare to HSG
med_hsg = pd.merge(medicare, hsg, on=['ZipCode'], how='left')

med_hsg = med_hsg[~med_hsg.ProviderID.isin(for_eric2["ProviderID"])]

indices = []

for index, row in med_hsg.iterrows():
    if type(row['HospitalName']) == str and type(row['Name']) == str and type(row['Address_x']) == str and type(row['Address_y']) == str:
        HospitalName = row['HospitalName'].lower()
        Name = row['Name'].lower()
        Address_x = row['Address_x'].lower()
        Address_y = row['Address_y'].lower()
        lev_name = Levenshtein.ratio(HospitalName, Name)
        lev_addr = Levenshtein.ratio(Address_x, Address_y)
        if (lev_name >= 0.9 and lev_addr >= 0.6) or (lev_name >= 0.55 and lev_addr >= 0.9):
            indices.append(index)
            print(HospitalName, ",", Address_x)
            print(Name, ",", Address_y, ",", Levenshtein.ratio(HospitalName, Name), ",", Levenshtein.ratio(Address_x, Address_y))

med_hsg_final = med_hsg.loc[indices]

# Format to Hive schema
med_hsg_final = med_hsg_final.drop(['Name', 'Address_y', 'City_y', 'State_y'], 1)
med_hsg_final = med_hsg_final.rename(columns={'Address_x' : 'Address', 'City_x' : 'City', 'State_x' : 'State', 'Grade' : 'SafetyGrade'})

# Add empty column for Yelp Rating
med_hsg_final['YelpRating'] = np.nan

# Write to CSV
# med_hsg_final.to_csv("Medicare_HSG.csv", index = False)

# Match Medicare to Yelp
med_yelp = pd.merge(medicare, yelp, on=['ZipCode'], how='left')

med_yelp = med_yelp[~med_yelp.ProviderID.isin(for_eric2["ProviderID"])]

indices = []

for index, row in med_yelp.iterrows():
    if type(row['HospitalName']) == str and type(row['Name']) == str and type(row['Address_x']) == str and type(row['Address_y']) == str:
        HospitalName = row['HospitalName'].lower()
        Name = row['Name'].lower()
        Address_x = row['Address_x'].lower()
        Address_y = row['Address_y'].lower()
        lev_name = Levenshtein.ratio(HospitalName, Name)
        lev_addr = Levenshtein.ratio(Address_x, Address_y)
        if (lev_name >= 0.9 and lev_addr >= 0.6) or (lev_name >= 0.55 and lev_addr >= 0.9):
            indices.append(index)
            print(HospitalName, ",", Address_x)
            print(Name, ",", Address_y, ",", Levenshtein.ratio(HospitalName, Name), ",", Levenshtein.ratio(Address_x, Address_y))

med_yelp_final = med_yelp.loc[indices]

med_yelp_final_grouped = med_yelp_final.groupby(["ProviderID", "HospitalName", "Address_x", "City_x", "State_x", "ZipCode",
                                  "HospitalOverallRating", "MortalityNationalComparison",
                                  "SafetyOfCareNationalComparison", "ReadmissionNationalComparison",
                                  "PatientExperienceNationalComparison", "EffectivenessOfCareNationalComparison",
                                  "TimelinessOfCareNationalComparison", "EfficientUseOfMedicalImagingNationalComparison",
                                  "AverageEffectiveCareScore", "AverageReadmissionScore"]).aggregate(np.mean).reset_index()

# Format to Hive schema
med_yelp_final_grouped = med_yelp_final_grouped.drop(['Unnamed: 0'], 1)
med_yelp_final_grouped = med_yelp_final_grouped.rename(columns={'Address_x' : 'Address', 'City_x' : 'City', 'State_x' : 'State', 'Rating' : 'YelpRating'})
med_yelp_final_grouped['SafetyGrade'] = np.nan

med_yelp_final_grouped = med_yelp_final_grouped[["ProviderID", "HospitalName", "Address", "City", "State", "ZipCode",
"HospitalOverallRating", "MortalityNationalComparison",
"SafetyOfCareNationalComparison", "ReadmissionNationalComparison",
"PatientExperienceNationalComparison", "EffectivenessOfCareNationalComparison",
"TimelinessOfCareNationalComparison", "EfficientUseOfMedicalImagingNationalComparison",
"AverageEffectiveCareScore", "AverageReadmissionScore", "SafetyGrade", "YelpRating"]]

# Write to CSV
# med_yelp_final_grouped.to_csv("Medicare_Yelp.csv", index = False)

# Medicare data with no matches to HSG or Yelp

# Append all three tables together and drop duplicates
merged_records = for_eric2.append([med_hsg_final, med_yelp_final_grouped])
merged_records = merged_records.drop_duplicates(["ProviderID"])

# Filter out "merged_records"
med_only_final = medicare[~medicare.ProviderID.isin(merged_records["ProviderID"])]

# Add empty columns for Saftey Grade and Yelp Rating
med_only_final['SafetyGrade'] = np.nan
med_only_final['YelpRating'] = np.nan

# Append Medicare only data
all_records = merged_records.append([med_only_final])

# Write to CSV
all_records.to_csv("all_records.csv", index = False)

print("Done")
