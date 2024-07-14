# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 14:07:20 2023

@author: joyse
"""

#This is the original code to string match for SMCE, updated code is in the Jupyter notebook file called SMCE Matching Code

#Imports
import pandas as pd
from rapidfuzz import fuzz

#-*- coding: utf-8 -*-

#Open the data
chile_data = pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/bbdd_final_Chile.dta")
smce_2medio = pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/Simce 2017/Simce 2° Medio 2017/Archivos DTA (Stata)/simce2m2017_rbd_publica_final.dta")
smce_4basico=pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/Simce 2017/Simce 4° Basico 2017/Archivos DTA (Stata)/simce4b2017_rbd_publica_final.dta")
smce_8basico=pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/Simce 2017/Simce 8° Basico 2017/Archivos DTA (Stata)/simce8b2017_rbd_publica_final.dta")


#Isolate columns in datasets
person_id=chile_data['idencuesta']
schools_2medio_smce=set(smce_2medio['nom_rbd'])
schools_4basico_smce=set(smce_4basico['nom_rbd'])
schools_8basico_smce=set(smce_8basico['nom_rbd'])


#Create a set of all schools in SMCE
reference_names=schools_2medio_smce | schools_4basico_smce | schools_8basico_smce


#Get the region codess of the reference schools
def get_region_code_from_reference(name):
    # Check which dataset the reference school belongs to based on the name
    if name in schools_2medio_smce:
        region_code = smce_2medio.loc[smce_2medio['nom_rbd'] == name, 'cod_reg_rbd'].iloc[0]
    elif name in schools_4basico_smce:
        region_code = smce_4basico.loc[smce_4basico['nom_rbd'] == name, 'cod_reg_rbd'].iloc[0]
    elif name in schools_8basico_smce:
        region_code = smce_8basico.loc[smce_8basico['nom_rbd'] == name, 'cod_reg_rbd'].iloc[0]
    else:
        region_code = None  # Handle the case if the reference school is not found in any dataset
    
    return region_code



#Create a dictionary mapping region names to region codes for the Chile dataset
region_dict={'METROPOLITANA': 13, 'BIO BIO': 8, 'VALPARAÍSO': 5}


#Create a matching of schools in Chile data to reference names based on string match and region similarity

# for index, row in chile_data.iterrows():
#     entry = row['c27_est'].upper()
#     region_s_code = region_dict[row['region_s'].upper()]
#     best_match = max(reference_names, key=lambda x: fuzz.ratio(entry, x))
    
    #ATTEMPT 1
    # if fuzz.ratio(entry, best_match) > 90: #Match for scores above 90
    #     normalized_schools.append(best_match)
    #     counter += 1
    # elif fuzz.ratio(entry, best_match) > 70 and region_s_code == get_region_code_from_reference(best_match): #Match for >70 if region matches
    #     normalized_schools.append(best_match)
    #     counter += 1
    
    #ATTEMPT 2
    # if region_s_code == get_region_code_from_reference(best_match):
    #     normalized_schools.append(best_match)
    #     counter += 1
        
    #ATTEMPT 3
    # normalized_schools.append(best_match)
    # counter+=1
    
    # else:
    #     normalized_schools.append(None)




#ATTEMPT 4
# threshold=85
# normalized_schools = []
# for index, row in chile_data.iterrows():
#     entry = row['c27_est'].upper()
#     region_s_code = region_dict[row['region_s'].upper()]
    
#     ratios = [(name, fuzz.ratio(entry, name)) for name in reference_names] #gets all ratios
#     ratios.sort(key=lambda x: x[1], reverse=True) #sorts in descending order
#     best_match=ratios[0][0] #gets the highest ratio
    
#     filtered_ratios = [(name, ratio) for name, ratio in ratios if ratio > threshold] #gets all schools above threshold
    
#     if len(filtered_ratios) > 0:
#         # Sort the filtered ratios by ratio in descending order
#         filtered_ratios.sort(key=lambda x: x[1], reverse=True)
#         #best_match=filtered_ratios[0][0]
#         # Iterate through the filtered ratios
#         for name, ratio in filtered_ratios:
#             if get_region_code_from_reference(name) == region_s_code:
#                 # Choose the highest match with the same region
#                 best_match=name
#                 break  # Exit the loop if a match is found  
                     
#     normalized_schools.append(best_match) 
    

###ATTEMPT 5, MAKE TWO COLUMNS, ONE WITH BEST MATCH ON REGION, ONE WITH BEST MATCH AND SEE WHICH IS BETTER 
#BEST MATCH BASED ON LOCATION
threshold=0
normalized_schools = []
for index, row in chile_data.iterrows():
    entry = row['c27_est'].upper()
    region_s_code = region_dict[row['region_s'].upper()]
    
    ratios = [(name, fuzz.ratio(entry, name)) for name in reference_names] #gets all ratios
    ratios.sort(key=lambda x: x[1], reverse=True) #sorts in descending order
    
    filtered_ratios = [(name, ratio) for name, ratio in ratios if ratio > threshold] #gets all schools above threshold
    best_match=None
    
    # Sort the filtered ratios by ratio in descending order
    filtered_ratios.sort(key=lambda x: x[1], reverse=True)
    #best_match=filtered_ratios[0][0]
    # Iterate through the filtered ratios
    for name, ratio in filtered_ratios:
        if get_region_code_from_reference(name) == region_s_code:
            # Choose the highest match with the same region
            best_match=name
            break  # Exit the loop if a match is found  
                     
    normalized_schools.append(best_match)   

#BEST MATCH IN GENERAL
normalized_schools1 = []
for index, row in chile_data.iterrows():
    entry = row['c27_est'].upper()
    region_s_code = region_dict[row['region_s'].upper()]
    
    ratios = [(name, fuzz.ratio(entry, name)) for name in reference_names] #gets all ratios
    ratios.sort(key=lambda x: x[1], reverse=True) #sorts in descending order
    best_match=ratios[0][0] #gets the highest ratio
                         
    normalized_schools1.append(best_match)      

counter=0
normalized_schools2=[]
for index, school in enumerate(normalized_schools):
    if school==normalized_schools1[index]:
        normalized_schools2.append(school)
        counter+=1
    else:
        normalized_schools2.append(None)

#Get the percent of matching        
print('percent matching schools', counter/len(normalized_schools))

#Create a new dataframe
chile_data_norm_school=pd.DataFrame({'idencuesta':person_id, 'c27_norm_best': normalized_schools1, 'c27_norm_reg': normalized_schools, 'c27_norm_final': normalized_schools2})
chile_data_norm_school.to_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/normalized_schools.dta", write_index=False, version=118)
chile_data_norm_school.to_csv("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/normalized_schools.csv")






