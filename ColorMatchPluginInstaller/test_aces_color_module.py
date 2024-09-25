import unittest
from unittest.mock import patch, MagicMock
from aces_color_module import apply_aces_color_management

class TestACESColorManagement(unittest.TestCase):

    @patch('aces_color_module.ocio.Config.CreateFromEnv')
    def test_apply_aces_color_management(self, mock_create_from_env):
        # Create a mock config and processor
        mock_config = MagicMock()
        mock_processor = MagicMock()
        mock_create_from_env.return_value = mock_config
        mock_config.getProcessor.return_value = mock_processor

        # Mock the applyRGB method
        mock_processor.applyRGB.return_value = [0.5, 0.5, 0.5]

        # Call the function
        image = [1.0, 1.0, 1.0]
        result = apply_aces_color_management(image)

        # Assertions
        mock_create_from_env.assert_called_once()
        mock_config.getProcessor.assert_called_once_with('scene_linear', 'ACES - ACEScg')
        mock_processor.applyRGB.assert_called_once_with(image)
        self.assertEqual(result, [0.5, 0.5, 0.5])

        class TestACESColorManagementWithSubprocess(unittest.TestCase):
        
            @patch('aces_color_module.subprocess.run')
            @patch('aces_color_module.ocio.Config.CreateFromEnv')
            def test_apply_aces_color_management(self, mock_create_from_env, mock_subprocess_run):
                # Mock subprocess.run to do nothing
                mock_subprocess_run.return_value = None
        
                # Create a mock config and processor
                mock_config = MagicMock()
                mock_processor = MagicMock()
                mock_create_from_env.return_value = mock_config
                mock_config.getProcessor.return_value = mock_processor
        
                # Mock the applyRGB method
                mock_processor.applyRGB.return_value = [0.5, 0.5, 0.5]
        
                # Call the function
                image = [1.0, 1.0, 1.0]
                result = apply_aces_color_management(image)
        
                # Assertions
                mock_subprocess_run.assert_any_call(["pip", "install", "PyOpenColorIO"], check=True)
                mock_create_from_env.assert_called_once()
                mock_config.getProcessor.assert_called_once_with('scene_linear', 'ACES - ACEScg')
                mock_processor.applyRGB.assert_called_once_with(image)
                self.assertEqual(result, [0.5, 0.5, 0.5])
        
        if __name__ == '__main__':
            unittest.main()

if __name__ == '__main__':
    unittest.main()