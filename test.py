filename = "1283PM"

if filename.endswith("pm") or filename.endswith("PM"):
    filename.replace("PM", "1")
    filename.replace("pm", "1")
    
print(filename)