import os
import shutil
import sys
import tkinter as tk
from tkinter import filedialog, messagebox
import subprocess

# Add the directory containing DaVinciResolveScript to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), 'scripts'))

try:
    import DaVinciResolveScript as dvr  # type: ignore
except ImportError:
    try:
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'DaVinciResolveScript'])
        import DaVinciResolveScript as dvr  # type: ignore
    except Exception as e:
        messagebox.showerror("Error", f"Failed to install DaVinciResolveScript: {e}")
        sys.exit(1)

# Add the directory containing aces_color_module to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), 'modules'))

import aces_color_module

# Your script logic goes here

import exifread  # type: ignore

# Replace with the actual module for ACES color conversion
import aces_color_module


# Function to extract metadata
def get_metadata(image_path):
    try:
        with open(image_path, 'rb') as f:
            tags = exifread.process_file(f)
        return tags
    except Exception as e:
        print("Error extracting metadata: {}".format(e))
        return None


# Function to match color using ACES standards
def match_color(metadata):
    """
    :param metadata:
    """
    try:
        # Convert metadata to ACES color
        aces_color = aces_color_module.convert_to_aces(metadata)
        # Convert ACES color to a format suitable for tkinter (e.g., hex color)
        matched_color = '#%02x%02x%02x' % (int(aces_color[0] * 255), int(aces_color[1] * 255), int(aces_color[2] * 255))
        return matched_color
    except Exception as e:
        print("Error matching color: {}".format(e))
        return '#FFFFFF'  # Default to white color in case of error


# Function to create a circle in the GUI
def create_circle(x, y, r, canvas, color):
    """
    Draws a circle on the given canvas.

    Parameters:
    x (int): The x-coordinate of the circle's center.
    y (int): The y-coordinate of the circle's center.
    r (int): The radius of the circle.
    canvas (Canvas): The canvas on which to draw the circle.
    color (str): The color of the circle's outline and fill.

    Returns:
    None

    Raises:
    Exception: If there is an error creating the circle.
    """
    try:
        canvas.create_oval(x - r, y - r, x + r, y + r, outline=color, fill=color, width=2)
    except Exception as e:
        print("Error creating circle: {}".format(e))


# Function to handle right-click event
def on_right_click(event, canvas):
    """
    Handles the right-click event on the canvas.

    This function is triggered when the user right-clicks on the canvas. It opens a file dialog for the user to select an image file,
    extracts metadata from the selected image, matches a color based on the metadata, and creates a circle on the canvas at the 
    click location with the matched color. If no file is selected, a warning message is shown. If metadata extraction fails, an 
    error message is shown.

    Args:
        event (tkinter.Event): The event object containing information about the right-click event.
        canvas (tkinter.Canvas): The canvas widget where the circle will be drawn.

    Raises:
        Exception: If an error occurs during the handling of the right-click event, it is caught and printed.
    """
    try:
        image_path = filedialog.askopenfilename()
        if image_path:
            metadata = get_metadata(image_path)
            if metadata:
                matched_color = match_color(metadata)
                create_circle(event.x, event.y, 50, canvas, matched_color)
            else:
                messagebox.showerror("Error", "Failed to extract metadata.")
        else:
            messagebox.showwarning("Warning", "No file selected.")
    except Exception as e:
        try:
            print("Error handling right-click event: {}".format(e))
        except:
            raise


# Main function to set up the GUI
def main():
    try:
        root = tk.Tk()
        root.title("Color Match GUI")
        canvas = tk.Canvas(root, width=400, height=400)
        canvas.pack()
        canvas.bind("<Button-3>", lambda event: on_right_click(event, canvas))  # Right-click event
        root.mainloop()
    except Exception as e:
        print("Error in main function: {}".format(e))


# Function to install the plugin
def install_plugin():
    """
    Installs the ColorMatchPlugin to DaVinci Resolve's Fusion Scripts directory.

    This function copies all files from the 'ColorMatchPlugin' directory to the
    DaVinci Resolve Fusion Scripts directory located at:
    '~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp'.
    If the target directory does not exist, it will be created.

    Raises:
        Exception: If there is an error during the installation process, an exception
                   will be caught and an error message will be printed.
    """
    try:
        plugin_dir = "ColorMatchPlugin"
        resolve_plugin_dir = os.path.expanduser("~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp")

        if not os.path.exists(resolve_plugin_dir):
            os.makedirs(resolve_plugin_dir)

        for filename in os.listdir(plugin_dir):
            full_file_name = os.path.join(plugin_dir, filename)
            if os.path.isfile(full_file_name):
                shutil.copy(full_file_name, resolve_plugin_dir)

        print("Plugin installed successfully!")
    except Exception as e:
        print("Error installing plugin: {}".format(e))


# Initialize DaVinci Resolve
try:
    resolve = dvr.scriptapp("Resolve")
    if resolve:
        install_plugin()
        main()
    else:
        print("DaVinci Resolve not found.")
except Exception as e:
    print("Error initializing DaVinci Resolve. Please ensure DaVinci Resolve is installed and the DaVinciResolveScript module is accessible. Detailed error: {}".format(e))
