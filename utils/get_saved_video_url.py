import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
from uuid import uuid4
import os
import json
from dotenv import load_dotenv

load_dotenv()

def get_saved_video_url(sessionId: str, videoName: str):
    service_account_str = os.getenv("SERVICE_ACCOUNT")
    service_account_obj = json.loads(service_account_str)

    if not firebase_admin._apps:
        cred = credentials.Certificate(service_account_obj)
        default_app = firebase_admin.initialize_app(cred, {
            'storageBucket': 'cricai-001.appspot.com'
        })
    bucket = storage.bucket()

    # Saving the file in the given path with the file name analysis.mp4
    path = "sessions/" + sessionId + "/" + videoName + "/analysis_video.mp4"

    blob = bucket.blob(path)

    token = uuid4()
    metadata  = {"firebaseStorageDownloadTokens": token}

    blob.metadata = metadata
    blob.upload_from_filename(filename='analysis.mp4', content_type='video/mp4')
    blob.make_public()

    url = blob.public_url

    return url

    # It should be authenticated in the future that the sessionId and videoName directory already exists in the storage
    # so that only verified users who knows the sessionId and the videoName can save video in the storage.
    # if exists then return save and return video url... else return ''
