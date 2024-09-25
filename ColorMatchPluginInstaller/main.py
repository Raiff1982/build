import os
import sys
import shutil
import logging
from tkinter import filedialog, messagebox

def install_plugin(plugin_dir):
	"""
	Installs the ColorMatchPlugin to the DaVinci Resolve Fusion Scripts directory.

	Args:
		plugin_dir (str): The directory containing the plugin files.

	Raises:
		FileNotFoundError: If the plugin directory does not exist.
		Exception: If there is an error during the installation process or if the operating system is unsupported.
	"""
	try:
		# Check if the plugin directory exists
		if not os.path.exists(plugin_dir):
			raise FileNotFoundError(f"The plugin directory '{plugin_dir}' does not exist.")
		
		# Determine the target directory based on the operating system
		if os.name == 'posix':  # For macOS and Linux
			if sys.platform == 'darwin':  # macOS
				resolve_plugin_dir = os.path.expanduser("~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp")
			else:  # Linux
				resolve_plugin_dir = os.path.expanduser("~/.local/share/DaVinciResolve/Fusion/Scripts/Comp")
		elif os.name == 'nt':  # For Windows
			resolve_plugin_dir = os.path.expandvars(r"%APPDATA%\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Comp")
		else:
			raise Exception("Unsupported operating system")

		# Create the target directory if it doesn't exist
		if not os.path.exists(resolve_plugin_dir):
			os.makedirs(resolve_plugin_dir)

		# Copy each item from the plugin directory to the target directory
		for item in os.listdir(plugin_dir):
			source = os.path.join(plugin_dir, item)
			destination = os.path.join(resolve_plugin_dir, item)
			if os.path.isdir(source):
				shutil.copytree(source, destination, False, None)
			else:
				shutil.copy2(source, destination)
				
		logging.info(f"Plugin installed successfully to {resolve_plugin_dir}")

	except FileNotFoundError as fnf_error:
		logging.error(f"File not found: {fnf_error}")
		raise
	except Exception as e:
		logging.error(f"An error occurred: {e}")
		raise

if __name__ == "__main__":
	try:
		plugin_dir = filedialog.askdirectory(title="Select Plugin Directory")
		if not plugin_dir:
			sys.exit("No directory selected.")
		
		install_plugin(plugin_dir)
	except ImportError:
		messagebox.showerror("Error", "aces_color_module not found. Ensure it is installed and the path is correct.")
		sys.exit(1)
	except Exception as e:
		messagebox.showerror("Error", f"An error occurred: {e}")
		sys.exit(1)