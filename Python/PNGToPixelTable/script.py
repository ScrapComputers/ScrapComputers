from PIL import Image, UnidentifiedImageError
import os
import json

def rgb_to_hex(color):
    """Convert an RGB tuple to a hex string (without #)."""
    return '{:02X}{:02X}{:02X}'.format(color[0], color[1], color[2])

def resize_image(image, target_width, target_height):
    """Resize the image to the target width and height."""
    return image.resize((target_width, target_height), Image.Resampling.LANCZOS)

def get_pixel_data(image):
    """Get pixel data from the image and output as a list of hex color strings."""
    hex_colors = []
    width, height = image.size
    
    for x in range(width):
        for y in range(height):
            try:
                color = image.getpixel((x, y))  # Get color as (R, G, B) tuple
                hex_color = rgb_to_hex(color)    # Convert to hex string without #
                hex_colors.append(hex_color)      # Add hex color to the list

            except Exception as e:
                print(f"Error retrieving pixel at ({x}, {y}): {e}")
                continue  # Skip to the next pixel if there's an error

    return hex_colors

def save_json(hex_colors, filename="output.json"):
    """Save the hex color data to a JSON file without pretty printing."""
    try:
        with open(filename, 'w') as file:
            json.dump(hex_colors, file)  # No indent for uglified output
        print(f"Data successfully exported to {filename}")
    except Exception as e:
        print(f"Failed to export data: {e}")

def get_valid_resolution(prompt):
    """Prompt for a valid integer resolution."""
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
        
        # Get the pixel data as a list of hex color strings
        hex_colors = get_pixel_data(resized_image)
        
        # Get the directory of the script to save output.json in the same folder
        script_dir = os.path.dirname(os.path.abspath(__file__))
        output_path = os.path.join(script_dir, "output.json")
        
        # Save the hex color data to the JSON file
        save_json(hex_colors, output_path)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    main()
