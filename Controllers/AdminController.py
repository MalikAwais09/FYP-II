
from sqlalchemy.orm import Session
from fastapi import UploadFile 
from Models.CourseEnrollment import CourseEnrollment
from Models.CourseOffering import CourseOffering

class AdminController:
    @staticmethod
    async def offer_course(file: UploadFile, db: Session):
        import pandas as pd
        from io import BytesIO
        content = await file.read()

        excel_file = BytesIO(content)

        df = pd.read_excel(excel_file)

        for _, item in df.iterrows():
                new_offering = CourseOffering(
                    CourseID=item["CourseID"],
                    Semester=item["Semester"],
                    DEPARTMENT=item.get("DEPARTMENT"),  # optional column
                    Year=item["Year"],
                    SESSION=item.get("SESSION")          # optional column
                )
                try:
                    db.add(new_offering)
                    db.commit()
                except Exception as e:
                    db.rollback()  # rollback the failed insert
                    return {"error": f"Database error: {str(e)}"}, 500

        return {"message": "Data inserted successfully"}

    @staticmethod
    async def add_enrollment(file: UploadFile, db: Session):
        import pandas as pd
        from io import BytesIO
        content = await file.read()

        excel_file = BytesIO(content)

        df = pd.read_excel(excel_file)

        for _, item in df.iterrows():
            new_enrollment = CourseEnrollment(
                StudentID = item["StudentID"],
                OfferingID = item["OfferingID"], 
                EnrollmentDate = item["EnrollmentDate"],
                Status = item["Status"]
            )
            try:
                db.add(new_enrollment)
                db.commit()
            except Exception as e:
                return {"error": f"Database error: {str(e)}"}, 500

        return {"message": "Data inserted successfully"}
