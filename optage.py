#!/usr/bin/python3
'''
  The Linux packages jpegoptim and optipng are required to run this script.

  This is a script to optimize images.
  Example : python3 optage.py
'''

import os
import shutil



dir = '.'
 
def check_packages():
  try:
    if 'jpegoptim' in shutil.which('jpegoptim') and 'optipng' in shutil.which('optipng'):
      return 0
  except:
    return 1
 
def optimization():
  png_count = 0
  jpg_count = 0
  jpeg_count = 0
 
  for root, dirs, files in os.walk(dir):
    for file in files:
      path = os.path.join(root, file)
      if os.path.splitext(path)[1] == '.png':
        png_count += 1 
        os.popen('optipng %s' % path)
      elif os.path.splitext(path)[1] == '.jpg':
        jpg_count += 1 
        os.popen('jpegoptim %s' % path)
      elif os.path.splitext(path)[1] == '.jpeg':
        jpeg_count += 1 
        os.popen('jpegoptim %s' % path)
  print('Optimized %d PNG, %d JPG, and %d JPEG files' % (png_count, jpg_count, jpeg_count))
 
if __name__ == "__main__":
  if check_packages() == 1:
    print('Make sure jpegoptim and optipng are installed.')
  else:
    optimization()
