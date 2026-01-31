from pydantic import BaseModel
from typing import List, Optional

class MCQOptionCreate(BaseModel):
    OPTION_TEXT: str
    IS_CORRECT: bool

class ExamMCQCreate(BaseModel):
    E_ID: int
    DESCRIPTION: str
    MARKS: int
    options: List[MCQOptionCreate] # list of options
