import cv2
import mediapipe as mp
import joblib
import math
from datetime import datetime

from pathlib import Path
DIR = Path(__file__).resolve().parent

svm_model_path = str(DIR.parent / "Models/svm_model.pkl")
scaler_path = str(DIR.parent / "Models/scaler.pkl")

class PoseEstimation:
    
    def __init__(self):
    # Load trained model
        self.svm = joblib.load(svm_model_path)
        self.scaler = joblib.load(scaler_path)
        self.mp_face = mp.solutions.face_mesh.FaceMesh(static_image_mode=True)


    @staticmethod
    def get_distance(p1, p2):
        return math.sqrt(
            (p1[0] - p2[0]) ** 2 +
            (p1[1] - p2[1]) ** 2 +
            (p1[2] - p2[2]) ** 2
        )

    def predict_pose(self, image):
        # image = cv2.rotate(image, cv2.ROTATE_90_CLOCKWISE)
        
        if image is not None:
            rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

            result = self.mp_face.process(rgb_image)


            if result.multi_face_landmarks is None:
                return "No face detected"
                exit()
            
            
            
            NOSE = 1
            LEFT_EYE = 33
            RIGHT_EYE = 263
            CHIN = 199

            landmarks = result.multi_face_landmarks[0].landmark
            getDistance = PoseEstimation.get_distance
            
            nose = [landmarks[NOSE].x, landmarks[NOSE].y, landmarks[NOSE].z]
            left_eye = [landmarks[LEFT_EYE].x, landmarks[LEFT_EYE].y, landmarks[LEFT_EYE].z]
            right_eye = [landmarks[RIGHT_EYE].x, landmarks[RIGHT_EYE].y, landmarks[RIGHT_EYE].z]
            chin = [landmarks[CHIN].x, landmarks[CHIN].y, landmarks[CHIN].z]

            face_width = getDistance(left_eye, right_eye)

            nose = [x / face_width for x in nose]
            left_eye = [x / face_width for x in left_eye]
            right_eye = [x / face_width for x in right_eye]
            chin = [x / face_width for x in chin]

            yaw = getDistance(nose, right_eye) - getDistance(nose, left_eye)

            eye_center = [
                (left_eye[0] + right_eye[0]) / 2,
                (left_eye[1] + right_eye[1]) / 2,
                (left_eye[2] + right_eye[2]) / 2
            ]

            pitch = getDistance(nose, chin) - getDistance(nose, eye_center)

            features = self.scaler.transform([[yaw, pitch]])
            prediction = self.svm.predict(features)
            
            # Saving the Evidence.
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
            if prediction[0] == "Right":
                save_path = str(DIR / f"output/Right/{timestamp}_pose.jpg")
                cv2.imwrite(save_path, image)
                
            elif prediction[0] == "Left":
                save_path = str(DIR / f"output/Left/{timestamp}_pose.jpg")
                cv2.imwrite(save_path, image)
                
            elif prediction[0] == "Front":
                save_path = str(DIR / f"output/Front/{timestamp}_pose.jpg")
                cv2.imwrite(save_path, image)
            else:
                save_path = str(DIR / f"output/NoPerson/{timestamp}_pose.jpg")
                cv2.imwrite(save_path, image)
                
            return prediction[0]
        else:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
            save_path = str(DIR / f"output/NoPerson/{timestamp}_noPerson.jpg")
            cv2.imwrite(save_path, image)
            print("image saved")
            return "No Face Detected"
    