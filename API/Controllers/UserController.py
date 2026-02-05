from sqlalchemy.orm import Session
from Models import (Users, Student, Teacher)
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
                userId, role = user
                
                id = 0
                if role.lower() == "teacher":
                    getID = db.query(Teacher.ID).filter(
                        Teacher.userID == userId
                    ).first()
                    id = getID[0]
                elif role.lower() == "student":
                    getID = db.query(Student.StudentID).filter(
                        Student.userID == userId
                    ).first()
                    id = getID[0]
                
                print(f"id = {id}")
                return {
                    "success": True,
                    "id": id,
                    "userID": userId,
                    "role": role,
                    }
        except Exception as e:
            print("database error")
            return {"error": f"Database error: {str(e)}"}, 500
        