import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os
import json
from dotenv import load_dotenv
from models.Metadata import Metadata
from google.cloud.firestore import FieldFilter

load_dotenv()

def fetch_metadata(shotType: str):
    service_account_str = os.getenv("SERVICE_ACCOUNT")
    service_account_obj = json.loads(service_account_str, strict=False)

    if not firebase_admin._apps:
        cred = credentials.Certificate(service_account_obj)
        app = firebase_admin.initialize_app(cred)
    
    db = firestore.client()

    docs = db.collection("metadata").where("shot_type", "==", shotType).stream()

    for doc in docs:
        data = doc.to_dict()
        return data["ideal_angles"]


    
