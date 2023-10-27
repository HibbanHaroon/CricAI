#Imports
import streamlit as st
from streamlit_player import st_player
import io
import time
from utils.get_pose_estimation_video import get_pose_estimation_video
from utils.read_data_from_file import read_data_from_file
from utils.write_data_to_file import write_data_to_file
from utils.get_compared_angles import get_compared_angles

def main():
    st.set_page_config(page_title="CricAI | Posture Comparison", page_icon="🏏")

    st.header("CricAI | Posture Comparison 🏏")
    st.markdown("Trying to compare your posture with the posture of an ideal player.")
    st.divider()

    with st.sidebar:
        st.subheader("Your Video")
        playerVideo = st.file_uploader("Upload your video and click 'Compare'", type=['mp4'])

        if playerVideo is not None:
            g = io.BytesIO(playerVideo.read())  ## BytesIO Object
            temporary_location = "input.mp4"

            with open(temporary_location, 'wb') as out:  ## Open temporary file as bytes
                out.write(g.read())  ## Read bytes into file

            # close file
            out.close()

        compareButton = st.button("Compare", type="primary")

    col1, col2 = st.columns(2)

    if compareButton:
        with st.spinner('Comparing the postures for you...'):
                        
            with col1:
                st.header("Your Video")

                ideal_angles = get_pose_estimation_video("ideal.mp4")

                # Write these ideal video angles in a file.
                write_data_to_file(ideal_angles, 'ideal_angles.json')

                # Reading ideal angles from the file.

                # This reading and writing angles data will be useful later when we would not spend time 
                # processing the ideal videos on the go. We simply process all the ideal videos, and then store the angles
                # calculated by the landmarks in text files, and then just simply 
                # read the selected ideal video angles when the user uploads a video.
                read_data = read_data_from_file('ideal_angles.json')

                player_angles = get_pose_estimation_video("input.mp4")

                # Comparing the player and ideal landmarks
                compared_angles = get_compared_angles(player_angles, read_data)
                print(compared_angles)

                idealVideo = open('output.mp4', 'rb')
                videoBytes = idealVideo.read()
                st.video(videoBytes)

            with col2:
                st.header("Ideal Player Video")

                get_pose_estimation_video("ideal.mp4")

                idealVideo = open('output.mp4', 'rb')
                videoBytes = idealVideo.read()
                st.video(videoBytes)
            
            st.success('Done!')

if __name__ == '__main__':
    main()