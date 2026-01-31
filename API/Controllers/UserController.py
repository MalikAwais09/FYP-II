from sqlalchemy.orm import Session
from Models.Users import Users

class UserController:

    @staticmethod
    def get_all_users(db: Session):
        result = db.query(Users).all()  
        users = [Users.to_dict(data) for data in result]
        return users

    

