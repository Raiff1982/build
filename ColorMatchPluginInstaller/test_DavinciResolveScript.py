import os
import shutil
import unittest
from unittest.mock import MagicMock, mock_open, patch

import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

try:
	from DavinciResolveScript import install_plugin
except ImportError:
	import sys
	sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
	from DavinciResolveScript import install_plugin

# Assuming the function install_plugin is imported from DavinciResolveScript

class TestInstallPlugin(unittest.TestCase):

	@patch('os.path.exists')
	@patch('os.makedirs')
	@patch('os.listdir')
	@patch('shutil.copy')
	@patch('os.path.isfile')
	@patch('os.path.join', side_effect=lambda *args: '/'.join(args))
	@patch('os.path.expanduser', return_value='/mocked/path')
	def test_install_plugin_success(self, mock_expanduser, mock_join, mock_isfile, mock_copy, mock_listdir, mock_makedirs, mock_exists):
		# Setup mocks
		mock_exists.side_effect = lambda path: path == '/mocked/path'
		mock_listdir.return_value = ['file1.py', 'file2.py']
		mock_isfile.return_value = True

		# Call the function
		install_plugin()

		# Assertions
		mock_expanduser.assert_called_once_with("~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp")
		mock_exists.assert_called_once_with('/mocked/path')
		mock_listdir.assert_called_once_with('ColorMatchPlugin')
		mock_isfile.assert_any_call('ColorMatchPlugin/file1.py')
		mock_isfile.assert_any_call('ColorMatchPlugin/file2.py')
		mock_copy.assert_any_call('ColorMatchPlugin/file1.py', '/mocked/path')
		mock_copy.assert_any_call('ColorMatchPlugin/file2.py', '/mocked/path')
		print("Plugin installed successfully!")

	@patch('os.path.exists')
	@patch('os.makedirs')
	@patch('os.listdir')
	@patch('shutil.copy')
	@patch('os.path.isfile')
	@patch('os.path.join', side_effect=lambda *args: '/'.join(args))
	@patch('os.path.expanduser', return_value='/mocked/path')
	def test_install_plugin_creates_directory(self, mock_expanduser, mock_join, mock_isfile, mock_copy, mock_listdir, mock_makedirs, mock_exists):
		# Setup mocks
		mock_exists.side_effect = lambda path: path != '/mocked/path'
		mock_listdir.return_value = ['file1.py', 'file2.py']
		mock_isfile.return_value = True

		# Call the function
		install_plugin()

		# Assertions
		mock_expanduser.assert_called_once_with("~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp")
		mock_exists.assert_called_once_with('/mocked/path')
		mock_makedirs.assert_called_once_with('/mocked/path')
		mock_listdir.assert_called_once_with('ColorMatchPlugin')
		mock_isfile.assert_any_call('ColorMatchPlugin/file1.py')
		mock_isfile.assert_any_call('ColorMatchPlugin/file2.py')
		mock_copy.assert_any_call('ColorMatchPlugin/file1.py', '/mocked/path')
		mock_copy.assert_any_call('ColorMatchPlugin/file2.py', '/mocked/path')
		print("Plugin installed successfully!")

	@patch('os.path.exists', return_value=True)
	@patch('os.makedirs')
	@patch('os.listdir', side_effect=Exception("Listdir error"))
	@patch('shutil.copy')
	@patch('os.path.isfile')
	@patch('os.path.join', side_effect=lambda *args: '/'.join(args))
	@patch('os.path.expanduser', return_value='/mocked/path')
	def test_install_plugin_listdir_error(self, mock_expanduser, mock_join, mock_isfile, mock_copy, mock_listdir, mock_makedirs, mock_exists):
		# Call the function
		with self.assertRaises(Exception) as context:
			install_plugin()

		# Assertions
		self.assertTrue("Listdir error" in str(context.exception))
		print("Error installing plugin: Listdir error")

if __name__ == '__main__':
	unittest.main()