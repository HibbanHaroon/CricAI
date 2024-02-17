from ultralytics import YOLO

model = YOLO('best.pt')

source = 'videos/video1.mov'
destination = 'clipped-videos/video1/'

results = model(source, stream=True, conf=0.25)

frame = 1

for result in results:
    print(result.boxes) 
    result.save(filename=destination + frame + '.jpg')