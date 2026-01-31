from db import Base
from sqlalchemy import Column, Integer, String, ForeignKey, Float
from sqlalchemy.orm import relationship

class DesAns(Base):
    __tablename__ = 'desans' #

    ID = Column(Integer, primary_key=True)
    Q_ID = Column(Integer, ForeignKey('examdescques.ID'))
    S_ID = Column(Integer, ForeignKey('student.StudentID'))
    ANSWERS = Column(String)

    # Relationships
    question_rship = relationship('ExamDescQues', back_populates='ans_rship')
    student_rship = relationship('Student', back_populates='des_ans_rship')