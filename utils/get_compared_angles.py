def get_compared_angles(player_angles, ideal_angles):
    # Convert keys to integers
    ideal_angles = {int(key): value for key, value in ideal_angles.items()}

    # Ensure both lists have the same length
    min_frames = min(len(player_angles), len(ideal_angles))

    # Dictionary to store frame-wise angle differences
    angles = {}

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
            frame_difference_angles.append(angle_difference)

        # Add the frame's angle differences to the dictionary
        angles[frame_index] = frame_difference_angles

    # Calculate mean angles
    mean_angles = [sum(frame_angles) / 12 for frame_angles in zip(*angles.values())]

    return mean_angles