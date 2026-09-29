import argparse
import os
from PIL import Image


def resize_images(directory, size=(800, 800), quality=80):
  """
  Resize images in the given directory to exact dimensions.
  size is a tuple of (width, height)
  """
  print(f"\nStarting image resize operation:")
  print(f"Target size: {size[0]}x{size[1]} pixels")
  print(f"Quality: {quality}%")
  print(f"Processing folder: {directory}\n")

  processed = 0
  skipped = 0
  failed = 0

  for root, _, files in os.walk(directory):
    for file in files:
      if file == '.DS_Store':
        continue
      if file.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
        image_path = os.path.join(root, file)

        try:
          with Image.open(image_path) as img:
            w, h = img.size
            print(f"\nProcessing: {file}")
            print(f"Original size: {w}x{h} pixels")

            # Resize to exact dimensions
            resized_img = img.resize((w // 2, h // 2), Image.Resampling.LANCZOS)

            # Save with original format
            if file.lower().endswith('.webp'):
              resized_img.save(image_path, "WEBP", quality=quality)
            else:
              resized_img.save(image_path, quality=quality)

            print(f"Resized to: {w // 2}x{h // 2} pixels")
            processed += 1
        except Exception as e:
          print(f"Failed to resize {image_path}: {e}")
          failed += 1

  print(f"\nResize operation completed:")
  print(f"Successfully processed: {processed} images")
  print(f"Failed: {failed} images")
  print(f"Skipped: {skipped} files")


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
      description='Resize images to exact dimensions')
  parser.add_argument('--folder', default='images',
                      help='Path to the folder containing images')
  parser.add_argument('--w', type=int, default=800,
                      help='Width of resized images')
  parser.add_argument('--h', type=int, default=800,
                      help='Height of resized images')
  parser.add_argument('--quality', type=int, default=80,
                      help='Quality of the output image (1-100)')

  args = parser.parse_args()
  resize_images(args.folder, size=(args.w, args.h), quality=args.quality)
