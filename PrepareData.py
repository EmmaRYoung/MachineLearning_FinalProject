#ML final project
#2/27

#create monte carlo simulation to generate 10,000 people, pull out their measurements
import numpy as np
#import numpy.linalg as LA
import torch
comp_device = torch.device("cpu")
from human_body_prior.body_model.body_model import BodyModel
from human_body_prior.tools.omni_tools import copy2cpu as c2c

#run validation code originally written in matlab, can run from python without rewriting
import matlab.engine
import time 
#want to run the slice and measure function
eng = matlab.engine.start_matlab()


## setup path and body model
bm_path_male = '../support_data/body_models/smplh/male/model.npz'
dmpl_path_male = '../support_data/body_models/dmpls/male/model.npz'

bm_path_female = '../support_data/body_models/smplh/female/model.npz'
dmpl_path_female = '../support_data/body_models/dmpls/female/model.npz'

num_betas = 10 # number of body parameters
num_dmpls = 8

#randomly sample SMPL shape distribution
N = 500

betas_store = np.empty((N,10))
#mesh_store = np.empty((N,6890,3))
magnitude_store = np.empty((6890,N))

pose_body = np.zeros((1,63))
pose_body = torch.Tensor(pose_body).to(comp_device) # controls the body

bm_male = BodyModel(bm_fname=bm_path_male, num_betas=num_betas, num_dmpls=num_dmpls, dmpl_fname=dmpl_path_male).to(comp_device)
bm_female = BodyModel(bm_fname=bm_path_female, num_betas=num_betas, num_dmpls=num_dmpls, dmpl_fname=dmpl_path_female).to(comp_device)


#define average vertices
StoreALL_M = np.empty((N,21))
StoreALL_F = np.empty((N,21))

start = time.time()
for i in range(N):
    print(i)
    
    #create random betas vector
    betas = np.random.normal(0,1, size = (1,10))#6*np.random.random((1,10))
    betas_store[i,:] = betas
    #betas = [0.892669,-0.091363,1.12808,1.44614,0.496969,0.801625,-0.464764,0.826711,0.295627,-0.574884]
    #betas = np.reshape(betas, (1,10))
    betas = torch.Tensor(betas).to(comp_device) # controls the body shape
    
    #feed into smpl scripts
    bodym = bm_male(pose_body=pose_body, betas=betas)
    bodyf = bm_female(pose_body=pose_body, betas=betas)
    
    #Get mesh vertices (male)
    verticesm = c2c(bodym.v[0])
    faces = c2c(bodym.f) + 1
    jointsm = c2c(bodym.Jtr[0])
    
    #Get mesh vertices (female)
    verticesf = c2c(bodyf.v[0])
    
    jointsf = c2c(bodyf.Jtr[0])
    
    #input to matlab fcn (vertices, faces, SJ, )
    faces = matlab.double(faces.tolist())
    
    #convert to correct data type
    verticesm = matlab.double(verticesm.tolist())
    jointsm = matlab.double(jointsm.tolist())
    
    verticesf = matlab.double(verticesf.tolist())
    jointsf = matlab.double(jointsf.tolist())
    
    '''
    np.savetxt("vertices.txt", verticesf, fmt = '%f')
    np.savetxt("faces.txt", faces, fmt = '%f')
    np.savetxt("SJ.txt", jointsf, fmt = "%f")
    '''
    
    BodyInformationm = np.double(eng.SliceAndMeasure2(verticesm, faces, jointsm, nargout=1))
    #remove the cupsize and bandsize measurement, then store
    #StoreM = np.delete(BodyInformationm, [1, 8])
    
    BodyInformationf = np.double(eng.SliceAndMeasure2(verticesf, faces, jointsf, nargout=1))
    #remove the chest measurement, then store
    #StoreF = np.delete(BodyInformationf, [7])
    
    StoreALL_F[i,:] = BodyInformationf
    StoreALL_M[i,:] = BodyInformationm
    end = time.time()
    print(start-end)
    
    
eng.quit()

#Save data

#np.savetxt("Betas_testing.txt", betas_store, fmt = '%f', delimiter = ',')
#np.savetxt("MaleMeasurements_testing.txt", StoreALL_M, fmt = '%f', delimiter = ',')
#np.savetxt("FemaleMeasurements_testing.txt", StoreALL_F, fmt = '%f', delimiter = ',')