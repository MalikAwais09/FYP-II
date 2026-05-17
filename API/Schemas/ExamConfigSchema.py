from pydantic import BaseModel
from typing import Optional

class ExamProctoringConfigBase(BaseModel):
    face_enabled: Optional[bool] = True
    face_suspicious_percent: Optional[int] = 20
    face_consecutive_limit: Optional[int] = 10

    voice_enabled: Optional[bool] = True
    voice_suspicious_percent: Optional[int] = 10
    voice_consecutive_limit: Optional[int] = 5

    object_detection_enabled: Optional[bool] = True
    object_detection_count_threshold: Optional[int] = 1

    action_on_threshold: Optional[str] = 'warn'
    warn_before_remove: Optional[bool] = True
    warning_count_before_remove: Optional[int] = 3

class ExamProctoringConfigCreate(ExamProctoringConfigBase):
    pass

class ExamProctoringConfigResponse(ExamProctoringConfigBase):
    id: int
    exam_id: int

    class Config:
        from_attributes = True
