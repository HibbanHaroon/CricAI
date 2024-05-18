def get_compared_angles(player_angles, ideal_angles):
    # Setting the threshold for angles... If the angle_difference is more than 20, then it means that angle is deviating. 
    THRESHOLD = 20
    # Convert keys to integers
    ideal_angles = {int(key): value for key, value in ideal_angles.items()}

    # Ensure both lists have the same length
    min_frames = min(len(player_angles), len(ideal_angles))

    # Dictionary to store frame-wise angle differences
    angles = {}

    # Dictionary to store the feedback - Angle: {count, total}
    feedback = {
        'Right Shoulder': {'count': 0, 'total': 0},
        'Left Shoulder': {'count': 0, 'total': 0},
        'Right Hip': {'count': 0, 'total': 0},
        'Left Hip': {'count': 0, 'total': 0},
        'Right Knee': {'count': 0, 'total': 0},
        'Left Knee': {'count': 0, 'total': 0},
        'Right Elbow': {'count': 0, 'total': 0},
        'Left Elbow': {'count': 0, 'total': 0},
        'Right Wrist': {'count': 0, 'total': 0},
        'Left Wrist': {'count': 0, 'total': 0},
        'Right Ankle': {'count': 0, 'total': 0},
        'Left Ankle': {'count': 0, 'total': 0},
    }

    # Loop through frames
    for frame_index in range(min_frames):
        frame_difference_angles = []

        # Loop through each angle
        for angle_index in range(12):
            player_angle = player_angles[frame_index][angle_index]
            
            # Access ideal angle using integer key
            ideal_angle = ideal_angles[frame_index][angle_index]

            # Calculate the difference for each corresponding angle
            angle_difference = player_angle - ideal_angle
            angle_information = {'angle_difference': angle_difference, 'is_deviation': ''}

            if abs(angle_difference) > THRESHOLD:
                key = list(feedback.keys())[angle_index]
                feedback[key]['count'] += 1
                feedback[key]['total'] += 1
                angle_information['is_deviation'] = 'DEVIATION'
            else:
                key = list(feedback.keys())[angle_index]
                feedback[key]['total'] += 1
                angle_information['is_deviation'] = 'OK'

            frame_difference_angles.append(angle_information)

        # Add the frame's angle differences to the dictionary
        angles[frame_index] = frame_difference_angles

    # Calculate mean angles
    # mean_angles = [sum(frame_angles) / 12 for frame_angles in zip(*angles.values())]

    return angles, feedback