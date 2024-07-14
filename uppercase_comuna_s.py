# -*- coding: utf-8 -*-
"""
Created on Fri Jul 28 17:44:16 2023

@author: joyse
"""
#Code to capitalize the comuna names in the dataset (I had problems using Stata so I used Python for this)

import pandas as pd

chile_data = pd.read_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/bbdd_final_Chile.dta")
comuna_s=chile_data['comuna_s']
person_id=chile_data['idencuesta']

comuna_s_capitalized = comuna_s.str.upper()
chile_data_capital_comuna=pd.DataFrame({'idencuesta':person_id, 'comuna_s_capitalized': comuna_s_capitalized})
chile_data_capital_comuna.to_stata("C:/Users/joyse/Dropbox (MIT)/Risky behavior/data/capital_comuna.dta", write_index=False, version=118)