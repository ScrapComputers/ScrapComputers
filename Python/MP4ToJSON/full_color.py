import cv2
import json
import numpy as np
import sys

def get_rectangles(frame, resWidth, visited):
    h, w, _ = frame.shape
    visited.fill(False)
    rectangles = []

    def find_rectangle(x, y, color):
        if visited[y, x]:
            return None

        max_x, max_y = x, y
        
        # Expand right
        while max_x + 1 < w and frame[y, max_x + 1, 0] == color[0] and not visited[y, max_x + 1]:
            max_x += 1
        
        # Expand down
        while max_y + 1 < h and np.all(frame[max_y + 1, x:max_x + 1, 0] == color[0]) and not np.any(visited[max_y + 1, x:max_x + 1]):
            max_y += 1
        
        visited[y:max_y + 1, x:max_x + 1] = True
        
        return [(y * resWidth + x + 1), ((max_y - y) * resWidth + (max_x - x + 1)), (int(color[0]) << 16) | (int(color[1]) << 8) | int(color[2])]

    for y in range(h):
        for x in range(w):
            if not visited[y, x]:
                rect = find_rectangle(x, y, frame[y, x])
                if rect:
                    rectangles.extend(rect)

    return [len(rectangles) // 3] + rectangles

def process_video(video_path, output_json, resize_dim):
    cap = cv2.VideoCapture(video_path)
    frame_count = 0
    visited = np.zeros((resize_dim[1], resize_dim[0]), dtype=bool)
    
    with open(output_json, 'w', buffering=64 * 1024) as f:
        f.write('[')
        first_frame = True
    
        while True:
            ret, frame = cap.read()
            if not ret:
                break

            frame = cv2.resize(frame, resize_dim, interpolation=cv2.INTER_NEAREST)
            rectangles = get_rectangles(frame, resize_dim[1], visited)
            
            if not first_frame:
                f.write(',')
            else:
                first_frame = False
            
            f.write(json.dumps(rectangles, separators=(',', ':')).strip("[]"))
            
            sys.stdout.write(f"\rProcessing frame {frame_count}...")
            sys.stdout.flush()
            frame_count += 1

        f.write(']')
    
    cap.release()
    print(f"\nFinished processing {frame_count} frames.")

process_video('input.mp4', 'output.json', (64, 64))
