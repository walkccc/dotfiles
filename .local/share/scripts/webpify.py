import argparse
import os

from PIL import Image


def convert_png_to_webp_and_delete(directory, quality=80, lossless=False):
  for root, _, files in os.walk(directory):
    for file in files:
      if not file.lower().endswith(".webp"):
        png_path = os.path.join(root, file)
        webp_path = os.path.splitext(png_path)[0] + ".webp"

        try:
          with Image.open(png_path) as img:
            img.save(webp_path, "webp", quality=quality, lossless=lossless)
          os.remove(png_path)
          print(f"Converted and deleted: {png_path} → {webp_path}")
        except Exception as e:
          print(f"Failed to convert {png_path}: {e}")


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
      description='Convert PNG files to WebP format')
  parser.add_argument('--folder', default='gif',
                      help='Path to the folder containing PNG files')
  args = parser.parse_args()
  convert_png_to_webp_and_delete(args.folder, quality=80, lossless=False)
