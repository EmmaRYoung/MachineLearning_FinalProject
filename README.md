# MachineLearning_FinalProject
A multi output regression model trained and validated with data generated from the Skinned Multi-Person Linear (SMPL) Model 

# Introduction and Motivation
While marker-based motion capture remains the gold standard in measuring human movement, accuracy is influenced by soft-tissue artifacts, particularly for markers that are not placed close to the underlying bone and for higher-BMI subjects. Obesity influences joint loads and motion patterns [1-2], and body mass index (BMI) may not be sufficient to capture the distribution of a subject’s weight or to differentiate differences between subjects.
The Skinned Multi Person Linear Model (SMPL) [3] body model is an opensource tool that can generate realistic 3D body shapes. It is created using thousands of body scans and motion capture data from the Archive of Motion Capture as Surface Shapes (AMASS) [4]. The shape of the model is described by 10 shape parameters, . And the pose of the body is described by 63 parameters, . 
It is advantageous to create a streamlined procedure to digitally recreate subjects with the SMPL model to create more realistic musculoskeletal models, estimate inertia and center of mass. Quantifying body habitus also allows for the consideration of torso-thigh, thigh-calf and other tissue contacts.

| ![image](https://github.com/EmmaRYoung/MachineLearning_FinalProject/assets/67296859/8a7fb020-8955-4a92-b178-cd8bed92440f)
|:--:| 
| *Space* |

