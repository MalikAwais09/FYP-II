from db import Base
from sqlalchemy import Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import relationship
class Exam(Base):
    __tablename__ = 'exam' #

    ID = Column(Integer, primary_key=True)
    A_ID = Column(Integer, ForeignKey('courseallocation.ID'))
    TITLE = Column(String(50), nullable=False)
    TOTAL_QUESTIONS = Column(Integer)
    E_DATE = Column(Date)
    START_TIME = Column(String(10))
    END_TIME = Column(String(10))
    E_TYPE = Column(String(6))
    STATUS = Column(String(7))

    # Relationships
    allocation_rship = relationship('CourseAllocation', back_populates='exam_rship')
    
    # Questions
    mcq_rship = relationship('ExamMCQ', back_populates='exam_rship') #
    desc_ques_rship = relationship('ExamDescQues', back_populates='exam_rship') #
    
    # Proctoring
    proctoring_rship = relationship('ProctoringEvent', back_populates='exam_rship') #

    student_seatings = relationship('StudentSeating', back_populates='exam_rship')
    break_rship = relationship('StudentBreak', back_populates='exam_rship')
    examroom_rship = relationship('ExamRoom', back_populates='exam_rship')

    def to_dict(self):
        return {
            "ID": self.ID,
            "TITLE": self.TITLE,
            "E_DATE": self.E_DATE.isoformat() if self.E_DATE else None,
            "START_TIME": self.START_TIME,
            "STATUS": self.STATUS
        }