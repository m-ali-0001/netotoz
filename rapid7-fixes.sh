#!/bin/bash

root_password=$1

echo "======= APPLYING RAPID7 FIXES ======="

echo "install cramfs /bin/true" >> /etc/modprobe.d/cramfs.conf
#rmmod cramfs

echo "install freevxfs /bin/true" >> /etc/modprobe.d/freevxfs.conf
#rmmod freevxfs

echo "install jffs2 /bin/true" >> /etc/modprobe.d/jffs2.conf
#rmmod jffs2

echo "install hfs /bin/true" >> /etc/modprobe.d/hfs.conf
#rmmod hfs

echo "install hfsplus /bin/true" >> /etc/modprobe.d/hfsplus.conf
#rmmod hfsplus

echo "install udf /bin/true" >> /etc/modprobe.d/udf.conf
#rmmod udf

sed -i 's/defaults,nofail,x-systemd.requires=cloud-init.service,comment=cloudconfig/defaults,nofail,x-systemd.requires=cloud-init.service,comment=cloudconfig,noexec/g' /etc/fstab
mount | grep /dev/shm

df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

chown root:root /boot/grub/grub.cfg
chmod og-rwx /boot/grub/grub.cfg

apt-get update -y
apt-get install expect -y
# echo "#!/usr/bin/expect -f

# spawn passwd root

# expect \"Enter new UNIX password:\"

# send -- \"$root_password\r\"

# expect \"Retype new UNIX password:\"

# send -- \"$root_password\r\"

# expect \"New password:\"

# send -- \"$root_password\r\"

# expect \"Retype new password:\"

# send -- \"$root_password\r\"

# expect eof
# " >> setRootPassword

# chmod +x setRootPassword
# # ./setRootPassword
# rm setRootPassword

echo "* hard core 0" >> /etc/security/limits.conf
echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
sysctl -w fs.suid_dumpable=0

echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
sysctl -w kernel.randomize_va_space=2

systemctl disable rsync

apt-get remove telnet -y

echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.conf
echo "nnet.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.conf
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

echo "net.ipv4.icmp_ignore_bogus_error_responses" >> /etc/sysctl.conf
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1

apt-get install tcpd -y

chmod -R g-wx,o-rwx /var/log/*

chown root:root /etc/crontab
chmod og-rwx /etc/crontab

chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly

chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily

chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly

chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly

chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d

rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow


cp sshd_config /etc/ssh/
# echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com" >> /etc/ssh/sshd_config
# sed -i 's/#PermitUserEnvironment no/PermitUserEnvironment no/g' /etc/ssh/sshd_config
# sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 300/g' /etc/ssh/sshd_config
# sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/g' /etc/ssh/sshd_config
# sed -i 's/#LoginGraceTime 2m/LoginGraceTime 60/g' /etc/ssh/sshd_config
# sed -i 's/#Banner none/Banner \/etc\/issue.net/g' /etc/ssh/sshd_config

# echo "Protocol 2" >> /etc/ssh/sshd_config
# sed -i 's/#LogLevel INFO/LogLevel INFO/g' /etc/ssh/sshd_config
# sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config
# sed -i 's/#MaxAuthTries 6/MaxAuthTries 4/g' /etc/ssh/sshd_config
# sed -i 's/#IgnoreRhosts yes/IgnoreRhosts yes/g' /etc/ssh/sshd_config
# sed -i 's/#HostbasedAuthentication no/HostbasedAuthentication no/g' /etc/ssh/sshd_config
# sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
# sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

apt-get install libpam-pwquality -y
sed -i 's/# minlen = 8/minlen = 14/g' /etc/security/pwquality.conf
sed -i 's/# dcredit = 0/dcredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# ucredit = 0/ucredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# lcredit = 0/lcredit = -1/g' /etc/security/pwquality.conf
sed -i 's/# ocredit = 0/ocredit = -1/g' /etc/security/pwquality.conf

echo "auth required pam_tally2.so onerr=fail audit silent deny=5 unlock_time=900" >> /etc/pam.d/common-auth
echo "password required pam_pwhistory.so remember=5" >> /etc/pam.d/common-auth

sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS   90/g' /etc/login.defs
sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS   7/g' /etc/login.defs

usermod -s /usr/sbin/nologin omsagent
passwd -l omsagent

usermod -s /usr/sbin/nologin nxautomation
passwd -l nxautomation

echo "umask 027" >> /etc/bash.bashrc
echo "umask 027" >> /etc/profile

echo "auth required pam_wheel.so" >> /etc/pam.d/su

echo "======= FIXES APPLIED - REVIEW ABOVE LOG ONCE ======="
