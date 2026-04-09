from sqlalchemy import Column, Integer, String, DateTime, Boolean
from .database import Base

class User(Base):
    __tablename__ = "users"
    id       = Column(Integer, primary_key=True, index=True)
    email    = Column(String,  nullable=False)
    name     = Column(String,  nullable=False)
    surname  = Column(String,  nullable=False)
    password = Column(String,  nullable=False)
    isadmin  = Column(Boolean, nullable=False)

class Car(Base):
    __tablename__ = "cars"
    id       = Column(Integer, primary_key=True, index=True)
    carclass = Column(Integer, nullable=False)
    price    = Column(Integer, nullable=False)
    capacity = Column(Integer, nullable=False)
    name     = Column(String,  nullable=False)

class Rent(Base):
    __tablename__ = "rents"
    id        = Column(Integer,  primary_key=True, index=True)
    carid     = Column(Integer,  nullable=False)
    userid    = Column(Integer,  nullable=False)
    datestart = Column(DateTime, nullable=False)
    dateend   = Column(DateTime, nullable=False)
    status    = Column(String,   nullable=False)
