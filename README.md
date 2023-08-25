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

Next, twelve regression models were fit to each of the datasets to narrow down on the best set of parameters and objective function to use. All regressions created in this project are from Scikit-learn’s MultiOutputRegressor class. The first four regressions test a linear least squares regression with l2 regularization, and varies the alpha parameter in the objective function:
![image](https://github.com/EmmaRYoung/MachineLearning_FinalProject/assets/67296859/ff1b0233-a914-46d7-b74c-16b5cf4885a2)

In these regressions, the intercept of the model is also fit, as it is unknown if the parameters should be centered or not.
The next four regressions vary the alpha parameter in the same way, but test the regression fit when the intercept of the model is not fit. 
The final four regressions test the use of a Kernel for fitting the data. This uses the same linear least squares with l2-norm regression, but the kernel trick is applied. Different weights for alpha are also tried during this method. The fit for each model is evaluated with a coefficient of determination R<sup>2</sup>.

 # Results 
 Linear Ridge Regression, Fitting Intercept
 | &alpha = 0.1 | &alpha = 1 | &alpha = 10 | &alpha = 100 |
 |:--:|:--:|:--:|:--:|
 | 0.9942 | 0.9927 | 0.9848 | 0.9227 |

 # Discussion
 The regression that performs the best for both male and female data is the linear ridge regression with the fitting intercept calculation turned on. While the fit is better for the female data in this case, on average the male data is described better by a wider range of regressions. The accuracy for the female model decreases quickly. For both the male and female data the fit worsens as the alpha value grows larger. When the intercept fitting is turned off, the model worsens. The fit is the worst when using the Kernel Trick. This is interesting to me, because I thought the problem would be nonlinear, and solved easier when using a kernel.

Next steps for this project could be investigating the accuracy of the regression fit by removing certain features from the dataset, and seeing which features are most important for the accuracy. It would be interesting to also run PCA on the dataset to also eliminate unimportant features. 

I plan to use this regression as part of my thesis defense as another way to create a subject specific SMPL model. Next, I will take the measurements from my data collection and generate a SMPL model from them. I plan to evaluate the SMPL model against subject point cloud data collected with an Azure Kinect camera with a KNN algorithm. 

