from datetime import datetime, timedelta, timezone
from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import HTTPBasic, HTTPBasicCredentials
from sqlalchemy.orm import Session
from pwdlib import PasswordHash
import yaml
import time
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Imports from local files
import db
import schemas
import endpoints
from db.database import Base, engine, SessionLocal
import db.database as appdb
import db.models as models
from endpoints.authService import router as authService
from endpoints.rentService import router as rentService
from endpoints.clientService import router as clientService
from endpoints.autoParkService import router as autoParkService

# ==================== Init FastAPI app ====================
# Create database tables if they dont exist yet
Base.metadata.create_all(bind=engine)

security = HTTPBasic()
app = FastAPI()
app.include_router(authService)
app.include_router(rentService)
app.include_router(clientService)
app.include_router(autoParkService)

# Dump documentation into yaml format
if __name__ == "__main__":
    with open("openapi.yaml", "w", encoding="utf-8") as f:
        yaml.safe_dump(app.openapi(), f, sort_keys=False, allow_unicode=True)


################# Endpoints #################
@app.get("/")
def read_root():
    return {"message": "Public endpoint"}
