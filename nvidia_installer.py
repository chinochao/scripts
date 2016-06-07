import urllib.request as req
import os
import sys
import re



nvidia_web = req.urlopen('http://www.nvidia.com/object/unix.html')
paragraphs = re.findall(r'<P>(.*?)Linux x86_64/AMD64/EM64T(.*?)</P>',str(nvidia_web.read()))
paragraphs_versions = re.findall(r'>([^<]*)</A>',str(paragraphs))

# http://us.download.nvidia.com/XFree86/Linux-x86_64/3VERSION/NVIDIA-Linux-x86_64-VERSION.run
# Latest NVidia Drivers
latest_ver = paragraphs_versions[0]
latest_url = ('http://us.download.nvidia.com/XFree86/Linux-x86_64/%s/NVIDIA-Linux-x86_64-%s.run' % (latest_ver, latest_ver))
latest_file = latest_url.split('/')[-1]
# Beta NVidia Drivers
beta_ver = paragraphs_versions[1]
beta_url = ('http://us.download.nvidia.com/XFree86/Linux-x86_64/%s/NVIDIA-Linux-x86_64-%s.run' % (beta_ver, beta_ver))
beta_file = beta_url.split('/')[-1]

def progress_bar(count, blockSize, totalSize):
  percent = int(count*blockSize*100/totalSize)
  sys.stdout.write('\r[**]' + latest_file + '....%d%%' % percent)
  sys.stdout.flush()



if __name__ == '__main__':
  try:
    print('[*]NVidia Drivers Setup')
    print('[**]Latest versions available are: \nStable: %s \nBeta: %s' % (latest_ver, beta_ver))
    version = input('Press [S] for Stable and [B] for Beta version: ')
    while True:
      if version.upper() == 'S':
        dl_ver = latest_ver
        dl_url = latest_url
        dl_file = latest_file
        break
      elif version.upper() == 'B':
        dl_ver = beta_ver
        dl_url = beta_url
        dl_file = beta_file
        break
      else:
        version = input('Press [S] for Stable and [B] for Beta version: ')
    print('[**]Downloading %s' % (dl_ver))
    dl_loc = ('%s/Downloads/%s' % (os.environ['HOME'], dl_file))
    req.urlretrieve(dl_url, dl_loc, reporthook=progress_bar)
    print('\n[**]NVidia Drivers downloaded: %s' % (dl_loc))
  except KeyboardInterrupt:
    print('Exiting ...')
