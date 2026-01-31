import cv2
from faceCount import FaceCounter

face_counter = FaceCounter()

image = cv2.imread("../pose_estimation_yaw_pitch/test_images/image1.pn")

count = face_counter.count_faces(image)
print("Faces detected:", count)

if count > 1:
    print("Cheating Detected: Multiple Faces")
else:
    print("Can't read image or image is not present.")