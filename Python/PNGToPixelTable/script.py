from PIL import Image, UnidentifiedImageError
import os

def rgb_to_hex(color):
    """Convert an RGB tuple to a hex string (without #)."""
    return '{:02X}{:02X}{:02X}'.format(color[0], color[1], color[2])

def resize_image(image, target_width, target_height):
    """Resize the image to the target width and height."""
    return image.resize((target_width, target_height), Image.Resampling.LANCZOS)

def get_pixel_data(image):
    """Get pixel data from the image and output as a single concatenated hex string."""
    hex_string = ""
    width, height = image.size
    
    for x in range(width):
        for y in range(height):
            try:
                color = image.getpixel((x, y))  # Get color as (R, G, B) tuple
                hex_color = rgb_to_hex(color)   # Convert to hex string without #
                hex_string += hex_color         # Concatenate hex colors into a single string

            except Exception as e:
                print(f"Error retrieving pixel at ({x}, {y}): {e}")
                continue  # Skip to the next pixel if there's an error

    return hex_string

def save_hex_string(hex_string, filename="output.txt"):
    """Save the concatenated hex string to a file."""
    try:
        with open(filename, 'w') as file:
            file.write(hex_string)
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
        
        # Get the pixel data as a single concatenated hex string
        hex_string = get_pixel_data(resized_image)
        
        # Get the directory of the script to save output.txt in the same folder
        script_dir = os.path.dirname(os.path.abspath(__file__))
        output_path = os.path.join(script_dir, "output.txt")
        
        # Save the concatenated hex string to the file
        save_hex_string(hex_string, output_path)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    main()
