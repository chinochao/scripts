#!/usr/bin/python3
import sys
import os
import configparser
import getpass
import time

# Global Variables
user_home = os.getenv('HOME')
s_folder = user_home + '/.s'
log_folder = s_folder + '/logs'
s_conf = s_folder + '/.s.conf'

try:
  import pexpect.pxssh as pxssh
except ImportError:
  print('Error: Cannot import Python module pxssh. Make sure module pexpect is installed.')
  sys.exit(1)

class User_Files:
  '''
  Class Example:
      User_Files.check_dirs()
      sso_user = User_Files.get_user()[0]
      sso_pass = User_Files.get_user()[1]
  '''
  def check_dirs():
    if os.path.isdir(s_folder):
      pass
    else:
      print('Setting Up User Files.')
      print('Creating needed directories and files.')
      os.mkdir(s_folder, 0o700)
      os.mkdir(log_folder, 0o700) 
      print('Created directories: \n%s\n%s ' % (s_folder,log_folder))
    if os.path.isfile(s_conf):
      pass
    else:
      print('Creating User Config File.')
      open(s_conf, 'w')
      os.chmod(s_conf, 0o600)
      print('Created file: \n%s' % s_conf)
      username = input('Enter SSO Username: ')
      password = getpass.getpass(prompt='Enter SSO Password: ')
      conf_file = open('/home/chaudric/.s/.s.conf', 'r+')
      config = configparser.ConfigParser()
      config.add_section('SSO_Details')
      config.set('SSO_Details', 'username', username)
      config.set('SSO_Details', 'password', password)
      config.write(conf_file)
      conf_file.close()

  def get_user():
    get_user = configparser.ConfigParser()
    get_user.read(s_conf)
    username = get_user.get('SSO_Details', 'username')
    password = get_user.get('SSO_Details', 'password')
    return (username, password) 

class Shell:
  '''
  Class Example:
      ssh = Shell(host, user, passw, log)
      ssh.ssh()
  '''
  def __init__(self, host, user, password, log):
    self.host = host
    self.user = user
    self.password = password
    self.log_file = log

  def ssh(self):
    shell = pxssh.pxssh(options={
                        "StrictHostKeyChecking": "no",
                        "UserKnownHostsFile": "/dev/null"})
    shell.force_password = True
    shell.login(self.host, self.user, password=self.password, auto_prompt_reset=False, port=22)                     
    shell.setwinsize(24,350)
    shell.logfile = self.log_file
    shell.interact()

if __name__ == '__main__':
  User_Files.check_dirs()
  sso_user = User_Files.get_user()[0]
  sso_pass = User_Files.get_user()[1]
  if len(sys.argv) >= 2:
    host = sys.argv[1]
    # Create and Open Log File
    log_file_name = '/%d_%s.log' % (int(time.mktime(time.gmtime())), host)
    log_file_location = log_folder + log_file_name
    log = open(log_file_location, 'wb')
    # Logging File End
    ssh = Shell(host, sso_user, sso_pass, log)
    ssh.ssh()
  else:
    print('Hostname missing. Please enter a hostname.') 
