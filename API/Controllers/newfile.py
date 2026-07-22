
from datetime import datetime, timedelta
from fastapi import HTTPException

@staticmethod
    def check_pose_alert(attempt_id: int, db: Session):
        try:
            # Last 10 seconds ki logs fetch karo
            ten_sec_ago = datetime.utcnow() - timedelta(seconds=10)

            recent_logs = db.query(StudentExamLog).filter(
                StudentExamLog.attempt_id == attempt_id,
                StudentExamLog.TIMESTAMP >= ten_sec_ago
            ).order_by(StudentExamLog.TIMESTAMP.asc()).all()

            if not recent_logs:
                return {"alert": False, "message": "No recent logs found"}

            # Consecutive same pose check
            first_pose = recent_logs[0].position

            # Agar sab same pose hain
            all_same = all(log.position == first_pose for log in recent_logs)

            if not all_same:
                return {"alert": False, "message": "Pose changing normally"}

            # Duration nikalo
            start_time = recent_logs[0].TIMESTAMP
            end_time = recent_logs[-1].TIMESTAMP
            duration = (end_time - start_time).total_seconds()

            # STRAIGHT pe alert mat karo
            if first_pose == "STRAIGHT":
                return {"alert": False, "message": "Straight pose is fine"}

            # 5 sec se zyada same pose → ALERT
            if duration >= 5:
                return {
                    "alert": True,
                    "pose": first_pose,
                    "duration": duration,
                    "message": f"Student has been looking {first_pose} for {duration:.1f} seconds!"
                }

            return {"alert": False, "duration": duration, "message": "Not enough duration yet"}

        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
        
        
        
@router.get('/check-pose-alert/{attempt_id}')
def check_pose_alert_route(attempt_id: int, db: Session = Depends(get_db)):
    return ProctoringController.check_pose_alert(attempt_id, db)