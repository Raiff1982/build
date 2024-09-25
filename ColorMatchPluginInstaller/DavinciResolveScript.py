import os
import shutil
import sys

def install_plugin():
	"""
	Installs the ColorMatchPlugin to the DaVinci Resolve Fusion Scripts directory.

	Raises:
		Exception: If there is an error during the installation process, an exception
				   will be caught and an error message will be printed.
	"""
	try:
		plugin_dir = "ColorMatchPlugin"
		
		if os.name == 'posix':
			# macOS or Linux
			if sys.platform == 'darwin':
				resolve_plugin_dir = os.path.expanduser("~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp")
			else:
				resolve_plugin_dir = os.path.expanduser("~/.local/share/DaVinciResolve/Fusion/Scripts/Comp")
		elif os.name == 'nt':
			# Windows
			resolve_plugin_dir = os.path.expandvars(r"%APPDATA%\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Comp")
		else:
			raise Exception("Unsupported operating system")

		# Ensure the plugin directory exists
		if not os.path.exists(resolve_plugin_dir):
			os.makedirs(resolve_plugin_dir)

		# Copy the plugin to the DaVinci Resolve Fusion Scripts directory
		for filename in os.listdir(plugin_dir):
			full_file_name = os.path.join(plugin_dir, filename)
			if os.path.isfile(full_file_name):
				shutil.copy(full_file_name, resolve_plugin_dir)
		print("ColorMatchPlugin installed successfully.")
	except Exception as e:
		print(f"Error during installation: {e}")

if __name__ == "__main__":
	# Call the install_plugin function
	install_plugin()

	# Change directory to the plugin_for_resolve directory and run the script
	os.chdir('path/to/plugin_for_resolve')

	# Your main script logic goes here
	print("Main script logic")