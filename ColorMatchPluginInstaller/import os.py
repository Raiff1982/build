import os
import tempfile

from main_script import get_metadata, match_color  # type: ignore


# Test get_metadata function
def test_get_metadata():
    # Create a temporary image file with EXIF data
    temp_image = tempfile.NamedTemporaryFile(delete=False, suffix=".jpg")
    temp_image.close()

    try:
        # Write some EXIF data to the temporary image file
        with open(temp_image.name, 'wb') as f:
            f.write(b'\xff\xd8\xff\xe1\x00\x18Exif\x00\x00MM\x00*\x00\x00\x00\x08\x00\x01\x01\x12\x00\x03\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00')

        # Call the get_metadata function
        metadata = get_metadata(temp_image.name)
        assert metadata is not None, "Metadata should not be None"
        print("get_metadata test passed.")
    finally:
        os.remove(temp_image.name)

# Test match_color function
def test_match_color():
    # Create a dummy metadata dictionary
    dummy_metadata = {
        'EXIF DateTimeOriginal': '2023:01:01 12:00:00',
        'EXIF ExposureTime': '1/60',
        'EXIF FNumber': '2.8',
        'EXIF ISOSpeedRatings': '100',
        'EXIF FocalLength': '50.0 mm'
    }

    # Call the match_color function
    matched_color = match_color(dummy_metadata)
    assert matched_color == '#FFFFFF', "Matched color should be white in case of error"
    print("match_color test passed.")

if __name__ == "__main__":
    test_get_metadata()
    test_match_color()