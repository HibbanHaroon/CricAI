
# CricAI
Generative AI-powered Cricket Coach

## Posture Comparison

### How does it work?
User will upload the video of a player. Firstly, angles of the ideal player are read from a json file.  

> *For now, we are also writing the ideal angles in a json file first, but later on we'll create a directory where all the angles and the videos of different ideal players for different shots will be placed.*

After reading the angles from a text file. Pose Estimation is performed on the player video and angles of the player's body are returned. These angles are then compared with the ideal player's angles. The difference between the angles is calculated and displayed to the user. 

### Further things to make comparison better
- Display the difference calculated on the player video
- Overlay the body of the ideal player of our player in the player video

### Utility Functions:
- [get_angle.py](https://github.com/enGenAIr/CricAI/blob/posture-comparison/utils/get_angle.py) - Calculating the common angle between two lines
- [get_compared_angles.py](https://github.com/enGenAIr/CricAI/blob/posture-comparison/utils/get_compared_angles.py) - Returns the angles compared between the player posture and the ideal posture
- [get_pose_estimation_video.py](https://github.com/enGenAIr/CricAI/blob/posture-comparison/utils/get_pose_estimation_video.py) - This saves the video after performing pose estimation on it and also returns the angles of the player's posture
- [read_data_from_file.py](https://github.com/enGenAIr/CricAI/blob/posture-comparison/utils/read_data_from_file.py) - Reads the angles of the ideal player from a json file
- [write_data_to_file.py](https://github.com/enGenAIr/CricAI/blob/posture-comparison/utils/write_data_to_file.py) - Writes angles of the ideal player to a json file

## Run Locally

Clone the project

```
  git clone https://github.com/enGenAIr/CricAI.git
```

Go to the project directory

```
  cd CricAI
```

Install dependencies

```
  pip install -r requirements.txt
```

Run the Streamlit app

```
  streamlit run app.py
```


## Acknowledgements

 - [Angle Calculation](https://medium.com/mlearning-ai/an-easy-guide-for-pose-estimation-with-googles-mediapipe-a7962de0e944)
