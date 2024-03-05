from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse, FileResponse
import json
import os
from utils.get_angles import get_angles
from utils.get_compared_angles import get_compared_angles

app = FastAPI()


@app.get('/')
async def root(url: str, request: Request):
    # Pose Estimation - get angles of the player's landmarks from the video of a session
    angles = get_angles(url)

    # Fetch Ideal Player Angles from Firebase... Given a name of the batting shot, it returns the angles 

    # Right Now, I haven't stored the metadata on Firebase... So, I am going to fetch one for now
    ideal_video_url = 'https://firebasestorage.googleapis.com/v0/b/cricai-001.appspot.com/o/ideal_videos%2Fideal.mp4?alt=media&token=e19e9ea3-cc1d-4db5-a7b3-8147ec25680e'
    ideal_angles = get_angles(ideal_video_url)

    # Shot Comparison - get compared angles of player and the ideal player
    compared_angles = get_compared_angles(angles, ideal_angles)

    return {'angles': angles, 'compared_angles': compared_angles}

# http://127.0.0.1:8000/?url=https://firebasestorage.googleapis.com/v0/b/cricai-001.appspot.com/o/ideal_videos%2Fideal.mp4?alt=media&token=e19e9ea3-cc1d-4db5-a7b3-8147ec25680e

@app.get('/video')
async def get_video():
    video_path = 'analysis.mp4'

    if not os.path.exists(video_path):
        raise HTTPException(status_code=404, detail="Video file not found")

    return FileResponse(path='analysis.mp4', media_type='application/octet-stream', filename='analysis.mp4')


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
