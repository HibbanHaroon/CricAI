import cv2
import mediapipe as mp
import numpy as np
import os
# from IPython.display import HTML
from utils.calculate_angle import calculate_angle

def get_angles(video):
    #Setup
    mp_pose = mp.solutions.pose
    mp_drawing = mp.solutions.drawing_utils
    mp_drawing_styles = mp.solutions.drawing_styles

    #Reading the Video File and Creating directory for the frames
    output_folder = "output_frames"  # Folder to save the frames
    output_video_path = "analysis.mp4"  # Output video file path
    cap = cv2.VideoCapture(video)
    frame_count = 0
    
    # Create the output frames folder
    os.makedirs(output_folder, exist_ok=True)

    # A dictory to store landmarks of all frames
    landmarks = {}

    # A dictionary to store angles between landmarks
    angles = {}

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

                # A list to store angles for each frame
                frame_angles = []
                    
                # A dictionary to store landmarks for each frame
                frame_landmarks = {}
                                
                # Extract and append these coordinates of each landmark to a list
                for idx, landmark in enumerate(results.pose_landmarks.landmark):
                    height, width, _ = image.shape
                    cx, cy = int(landmark.x * width), int(landmark.y * height)
                    
                    landmark_tuple = (cx, cy)
                    frame_landmarks[idx] = landmark_tuple

                    
                landmark_left_shoulder = frame_landmarks[11]
                landmark_right_shoulder = frame_landmarks[12]
                landmark_left_elbow = frame_landmarks[13]
                landmark_right_elbow = frame_landmarks[14]
                landmark_left_wrist = frame_landmarks[15]
                landmark_right_wrist = frame_landmarks[16]
                landmark_left_pinky = frame_landmarks[17]
                landmark_right_pinky = frame_landmarks[18]
                landmark_left_thumb = frame_landmarks[21]
                landmark_right_thumb = frame_landmarks[22]
                landmark_left_hip = frame_landmarks[23]
                landmark_right_hip = frame_landmarks[24]
                landmark_left_knee = frame_landmarks[25]
                landmark_right_knee = frame_landmarks[26]
                landmark_left_ankle = frame_landmarks[27]
                landmark_right_ankle = frame_landmarks[28]
                landmark_left_foot_index = frame_landmarks[31]
                landmark_right_foot_index = frame_landmarks[32]

                # Getting angle between the two lines
                angle0 = calculate_angle(landmark_right_elbow, landmark_right_shoulder, landmark_right_hip)
                angle1 = calculate_angle(landmark_left_elbow, landmark_left_shoulder, landmark_left_hip)
                angle2 = calculate_angle(landmark_right_shoulder, landmark_right_hip, landmark_right_knee)
                angle3 = calculate_angle(landmark_left_shoulder, landmark_left_hip, landmark_left_knee)
                angle4 = calculate_angle(landmark_right_hip, landmark_right_knee, landmark_right_ankle)
                angle5 = calculate_angle(landmark_left_hip, landmark_left_knee, landmark_left_ankle)
                angle6 = calculate_angle(landmark_right_wrist, landmark_right_elbow, landmark_right_shoulder)
                angle7 = calculate_angle(landmark_left_wrist, landmark_left_elbow, landmark_left_shoulder)
                angle8 = calculate_angle(landmark_right_pinky, landmark_right_wrist, landmark_right_thumb)
                angle9 = calculate_angle(landmark_left_pinky, landmark_left_wrist, landmark_left_thumb)
                angle10 = calculate_angle(landmark_right_knee, landmark_right_ankle, landmark_right_foot_index)
                angle11 = calculate_angle(landmark_left_knee, landmark_left_ankle, landmark_left_foot_index)

                # Adding angles to the list
                frame_angles.extend([angle0, angle1, angle2, angle3, angle4, angle5, angle6, angle7, angle8, angle9, angle10, angle11])

                angles[frame_count] = frame_angles

                landmarks[frame_count] = frame_landmarks

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

    return angles