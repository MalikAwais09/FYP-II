# from sentence_transformers import CrossEncoder
# print("Loading model...")
# model = CrossEncoder("cross-encoder/nli-deberta-v3-base")
# # model = CrossEncoder("cross-encoder/nli-MiniLM2-L6-H768")
# print("Model loaded!")
# print("Model loaded!")


import os
os.environ["TRANSFORMERS_OFFLINE"] = "1"
os.environ["HF_DATASETS_OFFLINE"] = "1"
os.environ["HF_HUB_OFFLINE"] = "1"  # ← yeh missing tha, yahi asli fix hai

from sentence_transformers import CrossEncoder
print("Loading model...")
model = CrossEncoder("cross-encoder/nli-deberta-v3-base")
print("Model loaded!")