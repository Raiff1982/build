import os
import shutil
import sys
import subprocess
import logging

# Configure logging to print messages to the console  
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s', handlers=[logging.StreamHandler(sys.stdout)])  

def get_resource_path(relative_path):  
    """ Get the absolute path to a resource, works for dev and for PyInstaller """  
    try:  
        # PyInstaller creates a temp folder and stores path in _MEIPASS  
        base_path = sys._MEIPASS  
    except AttributeError:  
        base_path = os.path.abspath(".")  

    return os.path.join(base_path, relative_path)  

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
        elif os.name == 'nt':  # For Windows
            resolve_plugin_dir = os.path.expandvars(r"%APPDATA%\Blackmagic Design\DaVinci Resolve\Fusion\Scripts\Comp")

        # Create the target directory if it doesn't exist  
        if not os.path.exists(resolve_plugin_dir):  
            os.makedirs(resolve_plugin_dir)  

        # Copy each item from the plugin directory to the target directory
        for item in os.listdir(plugin_dir):
            source = os.path.join(plugin_dir, item)
            destination = os.path.join(resolve_plugin_dir, item)
            # Copy each item from the plugin directory to the target directory
            for item in os.listdir(plugin_dir):
                source = os.path.join(plugin_dir, item)
                destination = os.path.join(resolve_plugin_dir, item)
                if os.path.isdir(source):
                    shutil.copytree(source, destination, dirs_exist_ok=True)
                else:
                    shutil.copy2(source, destination)
            if os.path.isdir(source):
                shutil.copytree(source, destination, dirs_exist_ok=True)
            else:
                shutil.copy2(source, destination)
                
        logging.info(f"Plugin installed successfully to {resolve_plugin_dir}")  

    except FileNotFoundError as fnf_error:  
        logging.error(f"File not found: {fnf_error}")  
        raise  
    except Exception as e:  
        logging.error(f"An error occurred: {e}")  
        raise  

def install_package(package_name):  
    """  
    Installs a Python package using pip.  

    Args:  
        package_name (str): The name of the package to install.  

    Raises:  
        Exception: If there is an error during the installation process.  
    """  
    try:  
        logging.info(f"Installing package: {package_name}")  
        result = subprocess.run([sys.executable, '-m', 'pip', 'install', package_name], check=True, capture_output=True, text=True)  
        logging.info(f"Package installation output: {result.stdout}")  
    except subprocess.CalledProcessError as e:  
        logging.error(f"Error installing package: {e}\nPackage installation stderr: {e.stderr}")  
        raise Exception(f"Error installing package: {e}\nPackage installation stderr: {e.stderr}")  
    except Exception as e:  
        logging.error(f"An unexpected error occurred: {e}")  
        raise Exception("An unexpected error occurred")
