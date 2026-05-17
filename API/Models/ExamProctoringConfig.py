from db import Base
from sqlalchemy import Column, Integer, Boolean, ForeignKey, DateTime, String
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.sql import func

class ExamProctoringConfig(Base):
    __tablename__ = 'ExamProctoringConfig'

    id = Column(Integer, primary_key=True, autoincrement=True)
    exam_id = Column(Integer, ForeignKey('exam.ID', ondelete="CASCADE"), unique=True, nullable=False)

    # Face Settings
    face_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    face_suspicious_percent: Mapped[int] = mapped_column(Integer, default=20)
    face_consecutive_limit: Mapped[int] = mapped_column(Integer, default=10)

    # Voice Settings
    voice_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    voice_suspicious_percent: Mapped[int] = mapped_column(Integer, default=10)
    voice_consecutive_limit: Mapped[int] = mapped_column(Integer, default=5)

    # Object Detection Settings
    object_detection_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    object_detection_count_threshold: Mapped[int] = mapped_column(Integer, default=1)

    # Action Settings
    action_on_threshold: Mapped[str] = mapped_column(String(10), default='warn')
    warn_before_remove: Mapped[bool] = mapped_column(Boolean, default=True)
    warning_count_before_remove: Mapped[int] = mapped_column(Integer, default=3)

    # Timestamps
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Relationship back to Exam
    exam_rship = relationship('Exam')
