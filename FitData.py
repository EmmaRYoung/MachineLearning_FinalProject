# -*- coding: utf-8 -*-
"""
Created on Thu Mar  9 15:00:17 2023

@author: swoosh
"""
import numpy as np
import pandas as pd 

from sklearn.multioutput import MultiOutputRegressor
from sklearn.linear_model import Ridge
from sklearn.kernel_ridge import KernelRidge

maleData_training = np.loadtxt("MaleMeasurements.txt", delimiter = ',')
femaleData_training = np.loadtxt("FemaleMeasurements.txt", delimiter = ',')

maleData_testing = np.loadtxt("MaleMeasurements_testing.txt", delimiter = ',')
femaleData_testing = np.loadtxt("FemaleMeasurements_testing.txt", delimiter = ',')

betas_training  = np.loadtxt("Betas.txt", delimiter = ',')
betas_testing= np.loadtxt("Betas_testing.txt", delimiter = ',')


#organize data
key = ["Ankle", "BandSize", "BiceptLower", "BiceptUpper", "Butt", "CalfLargest", "CalfUpper", "Chest", "CupSize", "ElbowToWrist", "FloorToShoulder", "ForearmLargest", "GroinToFloor", "Height", "ShoulderToElbow", "ShoulderToWrist", "ThighLength", "ThighLower", "ThighUpper", "Waist", "Wrist"]; 

male_df_training = pd.DataFrame(maleData_training, columns = key)
female_df_training = pd.DataFrame(femaleData_training, columns = key)

male_df_testing = pd.DataFrame(maleData_testing, columns = key)
female_df_testing = pd.DataFrame(femaleData_testing, columns = key)

#remove certain features from the data
#from male dataset, remove Band size and Cup Size
male_training = np.asarray(male_df_training.drop(columns = ["BandSize", "CupSize"]))
male_testing = np.asarray(male_df_testing.drop(columns = ["BandSize", "CupSize"]))

#from female dataset, remove chest measurement
female_training= np.asarray(female_df_training.drop(columns = ["Chest"]))
female_testing= np.asarray(female_df_testing.drop(columns = ["Chest"]))


#begin building regression model
#MALE
Mregr_01_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 0.1)).fit(male_training, betas_training)
Mregr_1_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 1)).fit(male_training, betas_training)
Mregr_10_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 10)).fit(male_training, betas_training)
Mregr_100_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 100)).fit(male_training, betas_training)

Mregr_01_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 0.1)).fit(male_training, betas_training)
Mregr_1_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 1)).fit(male_training, betas_training)
Mregr_10_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 10)).fit(male_training, betas_training)
Mregr_100_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 100)).fit(male_training, betas_training)

Mregr_01_KR = MultiOutputRegressor(KernelRidge(alpha = 0.1)).fit(male_training, betas_training)
Mregr_1_KR = MultiOutputRegressor(KernelRidge(alpha = 1)).fit(male_training, betas_training)
Mregr_10_KR = MultiOutputRegressor(KernelRidge(alpha = 10)).fit(male_training, betas_training)
Mregr_100_KR = MultiOutputRegressor(KernelRidge(alpha = 100)).fit(male_training, betas_training)


#FEMALE
Fregr_01_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 0.1)).fit(female_training, betas_training)
Fregr_1_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 1)).fit(female_training, betas_training)
Fregr_10_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 10)).fit(female_training, betas_training)
Fregr_100_R_IT = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=True, alpha = 100)).fit(female_training, betas_training)

Fregr_01_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 0.1)).fit(female_training, betas_training)
Fregr_1_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 1)).fit(female_training, betas_training)
Fregr_10_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 10)).fit(female_training, betas_training)
Fregr_100_R_IF = MultiOutputRegressor(Ridge(random_state=123, fit_intercept=False, alpha = 100)).fit(female_training, betas_training)

Fregr_01_KR = MultiOutputRegressor(KernelRidge(alpha = 0.1)).fit(female_training, betas_training)
Fregr_1_KR = MultiOutputRegressor(KernelRidge(alpha = 1)).fit(female_training, betas_training)
Fregr_10_KR = MultiOutputRegressor(KernelRidge(alpha = 10)).fit(female_training, betas_training)
Fregr_100_KR = MultiOutputRegressor(KernelRidge(alpha = 100)).fit(female_training, betas_training)


#test regression models
#MALE
print("Male")
print("\n")
Mscore_01_R_IT = Mregr_01_R_IT.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_01_R_IT)
print("\n")
Mscore_1_R_IT = Mregr_1_R_IT.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_1_R_IT)
print("\n")
Mscore_10_R_IT = Mregr_10_R_IT.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_10_R_IT)
print("\n")
Mscore_100_R_IT = Mregr_100_R_IT.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_100_R_IT)
print("\n")
print("\n")

Mscore_01_R_IF = Mregr_01_R_IF.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_01_R_IF)
print("\n")
Mscore_1_R_IF = Mregr_1_R_IF.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_1_R_IF)
print("\n")
Mscore_10_R_IF = Mregr_10_R_IF.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_10_R_IF)
print("\n")
Mscore_100_R_IF = Mregr_100_R_IF.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_100_R_IF)
print("\n")
print("\n")

Mscore_01_KR = Mregr_01_KR.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_01_KR)
print("\n")
Mscore_1_KR = Mregr_1_KR.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_1_KR)
print("\n")
Mscore_10_KR = Mregr_10_KR.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_10_KR)
print("\n")
Mscore_100_KR = Mregr_100_KR.score(male_testing, betas_testing, sample_weight=None)
print(Mscore_100_KR)
print("\n")

print("\n")
print("\n")

#FEMALE
print("Female")
print("\n")
Fscore_01_R_IT = Fregr_01_R_IT.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_01_R_IT)
print("\n")
Fscore_1_R_IT = Fregr_1_R_IT.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_1_R_IT)
print("\n")
Fscore_10_R_IT = Fregr_10_R_IT.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_10_R_IT)
print("\n")
Fscore_100_R_IT = Fregr_100_R_IT.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_100_R_IT)
print("\n")
print("\n")

Fscore_01_R_IF = Fregr_01_R_IF.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_01_R_IF)
print("\n")
Fscore_1_R_IF = Fregr_1_R_IF.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_1_R_IF)
print("\n")
Fscore_10_R_IF = Fregr_10_R_IF.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_10_R_IF)
print("\n")
Fscore_100_R_IF = Fregr_100_R_IF.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_100_R_IF)
print("\n")
print("\n")

Fscore_01_KR = Fregr_01_KR.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_01_KR)
print("\n")
Fscore_1_KR = Fregr_1_KR.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_1_KR)
print("\n")
Fscore_10_KR = Fregr_10_KR.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_10_KR)
print("\n")
Fscore_100_KR = Fregr_100_KR.score(female_testing, betas_testing, sample_weight=None)
print(Fscore_100_KR)
print("\n")
print("\n")

