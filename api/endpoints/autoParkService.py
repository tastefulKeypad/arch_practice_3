from datetime import datetime, timedelta, timezone
from typing import Annotated, List
import jwt
from jwt.exceptions import InvalidTokenError
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from pwdlib import PasswordHash

# Imports from local files
import db.database as appdb
import db.models as models
import schemas.car, schemas.token, schemas.rent
from endpoints.commonFunctions import *
from securityConfig import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES

passwordHash = PasswordHash.recommended()
oauth2Scheme = OAuth2PasswordBearer(tokenUrl="/token")
router = APIRouter(prefix="/autoParkService", tags=["autoParkService"])

# ====================== Endpoints ======================
@router.post("/add_car", response_model=schemas.car.CarResponse)
def add_car(
    car: schemas.car.CarCreate,
    tokenUser: Annotated[models.User, Depends(GetTokenUser)],
    db: Session = Depends(appdb.GetDB)
):
    """
    Create a new car and add it to database

    Must be admin to use this endpoint
    """
    if not tokenUser.isadmin:
        RaiseExceptionAdmin()

    newCar = models.Car(**car.model_dump())

    db.add(newCar)
    db.commit()
    db.refresh(newCar)
    return newCar

@router.get("/get_all_cars", response_model=List[schemas.car.CarResponse])
def get_all_cars(
    db: Session = Depends(appdb.GetDB)
):
    """
    Get list of all cars
    """
    return db.query(models.Car).all()

@router.get("/get_car_by_class", response_model=List[schemas.car.CarResponse])
def get_car_by_class(
    carclass: int,
    db: Session = Depends(appdb.GetDB)
):
    """
    Get all cars with given class
    """
    dbCar = db.query(models.Car).filter(
        models.Car.carclass == carclass
    ).all()
    if not dbCar:
        RaiseExceptionNoCar()
    return dbCar

@router.get("/check_available_cars", response_model=List[schemas.car.CarResponse])
def check_available_cars(
    datestart: datetime,
    dateend:   datetime,
    db: Session = Depends(appdb.GetDB)
):
    """
    Get list of all available cars in given time frame
    """
    dbBadCars = db.query(models.Rent).filter(
        (datestart < models.Rent.dateend) &
        (dateend   > models.Rent.datestart) &
        (models.Rent.status == "Active") 
    ).all()
    dbBadIds = [models.Rent.id for car in dbBadCars]
    dbCar = db.query(models.Car).filter(
        models.Rent.id.notin_(dbBadIds)
    ).all()

    if not dbCar:
        RaiseExceptionNoCar()
    return dbCar
