# Schemas/StudentAnswer.py
from pydantic import BaseModel
from typing import List
from Schemas.McqAnswer import McqAnswer

class StudentAnswer(BaseModel):
    S_ID: int
    answers: List[McqAnswer]   
