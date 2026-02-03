from sqlalchemy.orm import Session
from Models import (Users, Student)
from fastapi import UploadFile, File 
class UserController:

    @staticmethod
    def get_all_users(db: Session):
        result = db.query(Users).all()  
        users = [Users.to_dict(data) for data in result]
        return users

    
    @staticmethod
    def checkLogin(file: UploadFile, id: int, db: Session):
        try:
            userID = db.query(Users.ID).filter(
                Users.ID == id
            ).first()
            
            if not userID:
                return {"success": "No Record Found"}
            else:
                return {"sucess": userID.ID}
        except Exception as e:
            return {"error": f"Database error: {str(e)}"}, 500
        