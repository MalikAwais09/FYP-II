import cv2
import os 
from pathlib import Path
# -------------------------------
# Face Counter Class
# -------------------------------
class FaceCounter:
    def __init__(self):
        # Load OpenCV DNN face detector
        script_folder = Path(__file__).resolve().parent
        proto = str(script_folder / "deploy.prototxt")
        model = str(script_folder / "res10_300x300_ssd_iter_140000.caffemodel")
        
        self.net = cv2.dnn.readNetFromCaffe(
            proto,
            model
        )

    def count_faces(self, frame):
        if frame is not None:
            h, w = frame.shape[:2]

            # Convert image to blob
            blob = cv2.dnn.blobFromImage(
                frame,
                scalefactor=1.0,
                size=(300, 300),
                mean=(104.0, 177.0, 123.0)
            )

            self.net.setInput(blob)
            detections = self.net.forward()

            face_count = 0

            for i in range(detections.shape[2]):
                confidence = detections[0, 0, i, 2]

                # Lower confidence to detect far / small faces
                if confidence > 0.4:
                    face_count += 1

            return face_count
        else:
            return 0
