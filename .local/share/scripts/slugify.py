import argparse
import os
import re


def slugify_filename(filename: str) -> str:
  name, ext = os.path.splitext(filename)
  name = name.lower()
  # Remove apostrophes
  name = re.sub(r"['’]", "", name)
  # Replace any sequence of non-alphanumeric chars with hyphen
  name = re.sub(r"[^a-z0-9]+", "-", name)
  # Trim leading/trailing hyphens
  name = re.sub(r"^-+|-+$", "", name)
  return f"{name}{ext.lower()}"


def slugify_directory(directory: str):
  for filename in os.listdir(directory):
    old_path = os.path.join(directory, filename)
    if os.path.isfile(old_path):
      new_filename = slugify_filename(filename)
      new_path = os.path.join(directory, new_filename)

      if old_path != new_path:
        print(f"🔤 {filename} → {new_filename}")
        os.rename(old_path, new_path)


if __name__ == "__main__":
  parser = argparse.ArgumentParser(
      description='Slugify all filenames in a directory')
  parser.add_argument('--folder', required=True,
                      help='Path to the folder containing files')
  args = parser.parse_args()
  slugify_directory(args.folder)
