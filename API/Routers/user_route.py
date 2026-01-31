from fastapi import APIRouter, Request, Depends
from sqlalchemy.orm import Session
from db import get_db
from Controllers.UserController import UserController


router = APIRouter()

@router.get("/")
def welcome():
    return {"message": "welcome to FAST API "}


@router.get('/users')
def fetch_users(db: Session = Depends(get_db)):
    return UserController.get_all_users(db)
