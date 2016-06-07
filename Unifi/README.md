# Unifi Controller RPM Repo

## Synopsis

Ubiquiti Unifi Controller RPMs for personal use.

Enable and Start Service

`
[root@server ~]# systemctl enable unifi
Created symlink from /etc/systemd/system/multi-user.target.wants/unifi.service to /usr/lib/systemd/system/unifi.service.
[root@server ~]# systemctl start unifi
[root@server ~]# systemctl status unifi
● unifi.service - UniFi Controller Service
   Loaded: loaded (/usr/lib/systemd/system/unifi.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2016-06-07 11:50:58 CDT; 2s ago
 Main PID: 6021 (java)
   CGroup: /system.slice/unifi.service
           └─6021 /usr/bin/java -Xmx1024M -jar /opt/unifi/lib/ace.jar start

Jun 07 11:50:58 server systemd[1]: Started UniFi Controller Service.
Jun 07 11:50:58 server systemd[1]: Starting UniFi Controller Service...
`


Open Firewall Ports
`
[root@server ~]# firewall-cmd --list-ports
8080/tcp 8443/tcp
`
