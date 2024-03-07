from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse, FileResponse
import json
import os
from utils.get_angles import get_angles
from utils.get_compared_angles import get_compared_angles
from utils.get_saved_video_url import get_saved_video_url

app = FastAPI()


# Need sessionId and videoName with the url so that the analysis can be stored in the correct folder inside the sessions folder.
@app.get('/')
async def root(url: str, sessionId: str, videoName: str):
    # Pose Estimation - get angles of the player's landmarks from the video of a session
    angles = get_angles(url)

    # Right now, the analysis video is the video returned after performing pose estimation on the player's video.
    # Saving the analysis video in a Firebase Storage
    analysis_video = get_saved_video_url(sessionId=sessionId, videoName=videoName)

    # Fetch Ideal Player Angles from Firebase... Given a name of the batting shot, it returns the angles 

    # Right Now, I haven't stored the metadata on Firebase... So, I am going to fetch one for now
    ideal_video_url = 'https://firebasestorage.googleapis.com/v0/b/cricai-001.appspot.com/o/ideal_videos%2Fideal.mp4?alt=media&token=e19e9ea3-cc1d-4db5-a7b3-8147ec25680e'
    ideal_angles = get_angles(ideal_video_url)

    # Shot Comparison - get compared angles of player and the ideal player
    compared_angles = get_compared_angles(angles, ideal_angles)

    return {'compared_angles': compared_angles, 'analysis_video': analysis_video}

# sessionId='4PVCA5wMnxtkpqSt3cDS', videoName='VID-20240302-WA0040.mp4'
# http://127.0.0.1:8000/?url=https://firebasestorage.googleapis.com/v0/b/cricai-001.appspot.com/o/ideal_videos%2Fideal.mp4?alt=media&token=e19e9ea3-cc1d-4db5-a7b3-8147ec25680e

@app.get('/ideal/')
async def get_ideal_angles(url: str):
    ideal_angles = get_angles(url)

    return {ideal_angles}

    # This endpoint when hit with a url of the ideal player returns you the ideal angles. 
    # You can download the Json file by pressing "CTRL+S" 
    # or if you want the endpoint to give you a json file with the ideal angles. the code below helps you with that.

    # Code :
    # headers = {
    #     "Content-Disposition": f'attachment; filename=ideal_angles.json'
    # }

    # return JSONResponse(content=ideal_angles, headers=headers)
