# MachineLearning_FinalProject
A multi output regression model trained and validated with data generated from the Skinned Multi-Person Linear (SMPL) Model 

# Introduction and Motivation
While marker-based motion capture remains the gold standard in measuring human movement, accuracy is influenced by soft-tissue artifacts, particularly for markers that are not placed close to the underlying bone and for higher-BMI subjects. Obesity influences joint loads and motion patterns [1-2], and body mass index (BMI) may not be sufficient to capture the distribution of a subject’s weight or to differentiate differences between subjects.
The Skinned Multi Person Linear Model (SMPL) [3] body model is an opensource tool that can generate realistic 3D body shapes. It is created using thousands of body scans and motion capture data from the Archive of Motion Capture as Surface Shapes (AMASS) [4]. The shape of the model is described by 10 shape parameters, . And the pose of the body is described by 63 parameters, . 
It is advantageous to create a streamlined procedure to digitally recreate subjects with the SMPL model to create more realistic musculoskeletal models, estimate inertia and center of mass. Quantifying body habitus also allows for the consideration of torso-thigh, thigh-calf and other tissue contacts.

| ![image](https://github.com/EmmaRYoung/MachineLearning_FinalProject/assets/67296859/8a7fb020-8955-4a92-b178-cd8bed92440f)
|:--:| 
| (From left to right) The default SMPL model (shape = 0), the “morphed” SMPL model (shape = β), and the morphed and posed SMPL model (shape =  β, pose = ፀ) |

Extensive anthropometric measures were collected of subjects for a related project using depth cameras in the Human Dynamics Laboratory (HDL) at the University of Denver, the goal of this project is to predict the SMPL model of a person from these measurements. 

| ![image](https://github.com/EmmaRYoung/MachineLearning_FinalProject/assets/67296859/6bab34ed-0328-4544-8013-664cdf71ea04)
|:--:| 
| The circumference male measurements taken in the HDL |

| ![image](https://github.com/EmmaRYoung/MachineLearning_FinalProject/assets/67296859/7463060a-fb65-4531-8483-b10196ad656d)
|:--:| 
| The length measurements taken in the HDL |

# Methods
First, 3,000 SMPL models were randomly generated (1,500 male and 1,500 female models) and the shape parameters used to create them were stored for use in regression later. Each SMPL model was measured with custom Matlab code. The SMPL model’s scripts are all in python, so a python wrapper was created to call the Matlab function.
For male models, the measurements seen in Figures 2-3 were taken. The measurements for the female model are almost identical, except the chest measurement is replaced with a band size and cup size measurement.Shown below is an example of some, but not all, of the measurements. 
| ![image](https://github.com/EmmaRYoung/MachineLearning_FinalProject/assets/67296859/01d798b5-e3a3-478d-8bb1-0c1447fd7588)
|:--:|
| Circumference measurements on the male and SMPL model |

Full list of male measurements: (19 features)
* Ankle, BiceptLower, BiceptUpper, Butt, CalfLargest, CalfUpper, Chest, ElbowToWrist, FloorToShoulder, ForearmLargest, GroinToFloor, Height, ShoulderToElbow, ShoulderToWrist, ThighLength, ThighLower, ThighUpper, Waist, Wrist

Full list of female measurements: (21 features)
* Ankle,  BandSize, BiceptLower, BiceptUpper, Butt, CalfLargest, CalfUpper, CupSize, ElbowToWrist, FloorToShoulder, ForearmLargest, GroinToFloor, Height, ShoulderToElbow, ShoulderToWrist, ThighLength, ThighLower, ThighUpper, Waist, Wrist
