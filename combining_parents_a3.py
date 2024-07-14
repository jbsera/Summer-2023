# -*- coding: utf-8 -*-
"""
Created on Wed Aug  9 13:18:53 2023

@author: joyse
"""

#Code to get information on if the participant lives with their mom or dad currently
import pandas as pd

anexo_data=pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/Anexo 8 Base hogar Jovenes FINAL 20180110.dta")
chile_data = pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/bbdd_final_Chile_cleaned.dta")
person_id=chile_data['idencuesta']


#Initialize everyone as NOT living with mom or dad
dict_mom={}
dict_dad={}
for index in range(len(chile_data)):
    dict_mom[chile_data.at[index, 'idencuesta']]=0
    dict_dad[chile_data.at[index, 'idencuesta']]=0


#Go through the anexo dataset and change to 1 if they list their mom or dad
for index in range(len(anexo_data)):
    idencuesta = anexo_data.at[index, 'idencuesta']
    if anexo_data.at[index, 'a3']=='Mamá biológica':
        dict_mom[idencuesta]=1
    if anexo_data.at[index, 'a3']=='Papá biológico':
        dict_dad[idencuesta]=1
    
lives_with_mom=[]
lives_with_dad=[]

#Convert the dictionaries into a list
for key in dict_mom:
    lives_with_mom.append(dict_mom[key])

for key in dict_dad:
    lives_with_dad.append(dict_dad[key])



#Create a dataframe with idencuesta and information on if they live with mom or dad
chile_parents=pd.DataFrame({'idencuesta':person_id, 'lives_with_mom': lives_with_mom, 'lives_with_dad': lives_with_dad})
chile_parents.to_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/chile_parents.dta", write_index=False, version=118)






