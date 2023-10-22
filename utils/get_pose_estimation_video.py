import cv2
import mediapipe as mp
import numpy as np
import os
from IPython.display import HTML
from utils.get_angle import get_angle

def get_pose_estimation_video(video_path):
    #Setup
    mp_pose = mp.solutions.pose
    mp_drawing = mp.solutions.drawing_utils
    mp_drawing_styles = mp.solutions.drawing_styles

    #Reading the Video File and Creating directory for the frames
    output_folder = "output_frames"  # Folder to save the frames
    output_video_path = "output.mp4"  # Output video file path
    cap = cv2.VideoCapture(video_path)
    frame_count = 0
    
    # Create the output frames folder
    os.makedirs(output_folder, exist_ok=True)

    #Drawing Pose Landmarks and Extracting Coordinates of each landmark
    with mp_pose.Pose(
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5) as pose:
        while cap.isOpened():
            success, image = cap.read()
            if not success:
                print("Ignoring... No Video Frame")
                break

            # Process frame
            image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
            results = pose.process(image)

            # Drawing
            image.flags.writeable = True
            image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

            if results.pose_landmarks:

                # Draw pose landmarks
                mp_drawing.draw_landmarks(
                    image,
                    results.pose_landmarks,
                    mp_pose.POSE_CONNECTIONS,
                    landmark_drawing_spec=mp_drawing_styles.get_default_pose_landmarks_style()
                )

                # A dictory to store landmarks of all frames
                landmarks = {}

                # A dictionary to store landmarks for each frame
                frame_landmarks = {}
                                
                # Extract and append these coordinates of each landmark to a list
                for idx, landmark in enumerate(results.pose_landmarks.landmark):
                    height, width, _ = image.shape
                    cx, cy = int(landmark.x * width), int(landmark.y * height)
                    
                    landmark_tuple = (cx, cy)
                    frame_landmarks[idx] = landmark_tuple

                    
                landmark12 = frame_landmarks[12]
                landmark14 = frame_landmarks[14]
                landmark24 = frame_landmarks[24]

                # Get angle between the two lines i.e., 12 14 and 14 24 with a common point 14. 
                print(get_angle(landmark12, landmark14, landmark24))

                landmarks[frame_count] = frame_landmarks

                # print(landmarks)

                # Save combined image as frame
                frame_path = os.path.join(output_folder, f"frame_{frame_count:05d}.jpg")
                cv2.imwrite(frame_path, image)

                frame_count += 1

            if cv2.waitKey(5) & 0xFF == 27:
                break
    
    #Combining frames into video
    frame_files = sorted(os.listdir(output_folder))
    frame_paths = [os.path.join(output_folder, f) for f in frame_files]
    frame = cv2.imread(frame_paths[0])
    height, width, _ = frame.shape

    fourcc = cv2.VideoWriter_fourcc(*'h264')
    out = cv2.VideoWriter(output_video_path, fourcc, 30.0, (width, height), isColor=True)

    for frame_path in frame_paths:
        frame = cv2.imread(frame_path)
        out.write(frame)

    out.release()
    cap.release()
    print("Video saved successfully!")
