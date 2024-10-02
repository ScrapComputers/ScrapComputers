import json
from PIL import Image, UnidentifiedImageError
import os

def resize_image(image, target_width, target_height):
    return image.resize((target_width, target_height), Image.ANTIALIAS)

def get_pixel_data(image):
    pixel_data = []
    width, height = image.size
    for y in range(height):
        for x in range(width):
            color = image.getpixel((x, y))  # Get color as (R, G, B) tuple
            hex_color = '#{:02x}{:02x}{:02x}'.format(*color)  # Convert to hex
            pixel_data.append({'x': x + 1, 'y': y + 1, 'color': hex_color})
    return pixel_data

def export_to_json(data, filename="output.json"):
    try:
        with open(filename, 'w') as json_file:
            json.dump(data, json_file, indent=4)
        print(f"Data successfully exported to {filename}")
    except Exception as e:
        print(f"Failed to export data: {e}")

def get_valid_resolution(prompt):
    while True:
        try:
            value = int(input(prompt))
            if value <= 0:
                raise ValueError
            return value
        except ValueError:
            print("Please enter a valid positive integer.")

def main():
    try:
        # Prompt user for image file
        image_path = input("Enter the path to the PNG image: ")
        
        # Check if the file exists
        if not os.path.exists(image_path):
            print(f"Error: File '{image_path}' not found.")
            return
        
        # Open image
        try:
            image = Image.open(image_path)
        except UnidentifiedImageError:
            print("Error: The file is not a valid image or is in an unsupported format.")
            return

        # Prompt user for desired resolution
        target_width = get_valid_resolution("Enter desired width: ")
        target_height = get_valid_resolution("Enter desired height: ")
        
        # Resize image to desired resolution
        resized_image = resize_image(image, target_width, target_height)
        
        # Get the pixel data as a table
        pixel_table = get_pixel_data(resized_image)
        
        # Get the directory of the script to save output.json in the same folder
        script_dir = os.path.dirname(os.path.abspath(__file__))
        output_path = os.path.join(script_dir, "output.json")
        
        # Export pixel data to output.json
        export_to_json(pixel_table, output_path)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    main()
