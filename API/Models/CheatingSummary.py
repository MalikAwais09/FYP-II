from sqlalchemy import Column, Integer, ForeignKey, Boolean, Float
from sqlalchemy.orm import relationship
from db import Base


class CheatingSummary(Base):
    __tablename__ = "cheatingsummary"

    id = Column(Integer, primary_key=True, autoincrement=True)

    attempt_id = Column(Integer, ForeignKey("examattempt.ID"), nullable=False)

    is_voice_suspicious = Column(Boolean, nullable=True, default=False)

    is_face_suspicious = Column(Boolean, nullable=True, default=False)

    is_object_suspicious = Column(Boolean, nullable=True, default=False)
    
    sus_voice_percentage = Column(Float, default = 0.0)
    sus_face_percentage  = Column(Float, default = 0.0)
    

    # Optional relationship
    exam_attempt_rship = relationship("ExamAttempt", back_populates="cheating_summary_rship")