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
        # import time 
        try:
            # time.sleep(5)
            user = db.query(Users.ID, Users.Role).filter(
                Users.identity_no == id
            ).first()
            
            if user is None:
                return {"error": "No User Found"}
            else:
                id, role = user
                return {
                    "success": True,
                    "userID": id,
                    "role": role
                    }
        except Exception as e:
            print("database error")
            return {"error": f"Database error: {str(e)}"}, 500
        