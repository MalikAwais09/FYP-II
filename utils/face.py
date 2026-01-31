import face_recognition

def generate_embedding(image_path):
    image = face_recognition.load_image_file(image_path)
    encodings = face_recognition.face_encodings(image)
    print(encodings[0] if encodings else print('no image found')) 
    # return encodings[0] if encodings else None
generate_embedding('/Assets/Images/image.png')
