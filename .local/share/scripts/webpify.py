import argparse
import os
import shutil
from pathlib import Path

from PIL import Image


def convert_png_to_webp_and_preserve(
    directory: str,
    backup_dir: str,
    quality: int = 100,
    lossless: bool = True
) -> None:
  backup_dir = Path(backup_dir)
  backup_dir.mkdir(parents=True, exist_ok=True)

  for root, _, files in os.walk(directory):
    for file in files:
      if file == '.DS_Store':
        continue
      if not file.lower().endswith(".webp"):
        png_path = Path(root) / file
        webp_path = png_path.with_suffix(".webp")

        try:
          # backup original PNG
          backup_path = backup_dir / png_path.name
          shutil.copy2(png_path, backup_path)

          # convert to WebP
          with Image.open(png_path) as img:
            img.save(webp_path, "WEBP", quality=quality, lossless=lossless)

          # delete original
          os.remove(png_path)
          print(f"✅ {png_path} → {webp_path} (backup: {backup_path})")

        except Exception as e:
          print(f"❌ Failed to convert {png_path}: {e}")


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
      description="Convert PNG files to WebP format (lossless) and preserve originals.")
  parser.add_argument("--folders", "-f", nargs='+',
                      default=["/some/path/to/images"],
                      help="Path(s) to the folder(s) containing PNG files")
  parser.add_argument("--backup", "-b",
                      default="/tmp/images",
                      help="Folder to store original PNGs")
  args = parser.parse_args()

  for folder in args.folders:
    print(f"Processing folder: {folder}")
    convert_png_to_webp_and_preserve(folder, args.backup,
                                     quality=100, lossless=True)
