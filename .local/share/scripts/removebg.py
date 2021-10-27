import argparse
import os

from PIL import Image
from rembg import remove


def remove_background_recursively(directory):
  for root, _, files in os.walk(directory):
    for file in files:
      if file == '.DS_Store':
        continue
      if file.lower().endswith(".gif"):
        input_path = os.path.join(root, file)
        output_path = os.path.join(root, f"{file}")

        try:
          input_image = Image.open(input_path)
          output_image = remove(input_image)
          output_image.save(output_path)
          print(f"Removed background: {input_path} → {output_path}")
        except Exception as e:
          print(f"Failed to process {input_path}: {e}")


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
      description='Convert PNG files to WebP format')
  parser.add_argument('--folder', default='gif',
                      help='Path to the folder containing PNG files')
  args = parser.parse_args()
  remove_background_recursively(args.folder)
