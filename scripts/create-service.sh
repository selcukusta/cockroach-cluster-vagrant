#!/bin/bash
function join {
     local IFS="$1"; shift; echo "$*";
}
arr=()
counter=1
while [ $counter -le $1 ]
  do
    arr+=($2$counter':26257')
    ((counter++))
  done
JOIN_LIST=$(join , ${arr[@]})
echo $JOIN_LIST
sudo mkdir /var/lib/cockroach
sudo cat > /etc/systemd/system/cockroachdb.service  << EOF
[Unit]
Description=Cockroach Database cluster node
Requires=network.target
[Service]
Type=notify
WorkingDirectory=/var/lib/cockroach
ExecStart=/usr/local/bin/cockroach start --insecure --advertise-host=$3 --join=$JOIN_LIST --cache=.25 --max-sql-memory=.25
TimeoutStopSec=60
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cockroach
User=root
[Install]
WantedBy=default.target
EOF