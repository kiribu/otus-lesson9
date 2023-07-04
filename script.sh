#!/bin/bash




# create service config file
    
    sudo bash -c "cat > /etc/sysconfig/watchlog << EOF
# Configuration file for my watchdog service
# Place it to /etc/sysconfig
# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF"


# create Log File

    sudo bash -c "cat > /var/log/watchlog.log << EOF
The first item in the log entry is the date and time of the message. The next is the module producing the message (core, in this case) and the severity level of that message. This is followed by the process ID and, if appropriate, the thread ID, of the process that experienced the condition. Next, we have the client address that made the request. And finally is the detailed error message, which in this case indicates a request for a file that did not exist.
A very wide variety of different messages can appear in the ALERT error log. Most look similar to the example above. The error log will also contain debugging output from CGI scripts. Any information written to stderr by a CGI script will be copied directly to the error log.
EOF"

 # create Scritp
    
    sudo bash -c 'cat > /opt/watchlog.sh << EOF
#!/bin/bash
WORD=\$1
LOG=\$2
DATE='date'
if grep \$WORD \$LOG &> /dev/null
then
logger "\$DATE: I found word, Master!"
else
exit 0
fi
EOF'


# +Execute

    sudo chmod +x /opt/watchlog.sh


# create service file
    
    sudo bash -c 'cat > /etc/systemd/system/watchlog.service << EOF
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
EOF'

# create service timer file
    
    sudo bash -c "cat > /etc/systemd/system/watchlog.timer << EOF
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF"


 # restart daemon, enable and start service
   
    sudo systemctl daemon-reload 
    
    sudo systemctl start watchlog.service
    sudo systemctl enable watchlog.timer
    sudo systemctl start watchlog.timer
    
  # Result check

    sudo   tail -f /var/log/messages