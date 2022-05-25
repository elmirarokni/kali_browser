#!/bin/bash


#set vnc password
mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Start VNC server
vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH -localhost \
> /var/log/vncserver.log 2>&1

# Start noVNC server

if [ ! -f /etc/ssl/certs/novnc_cert.pem -o ! -f /etc/ssl/private/novnc_key.pem ]
then
  openssl req -new -x509 -days 365 -nodes \
    -subj "/C=US/O=OpenSource/CN=localhost" \
    -out /etc/ssl/certs/novnc_cert.pem -keyout /etc/ssl/private/novnc_key.pem \
    > /dev/null 2>&1
fi

cat /etc/ssl/certs/novnc_cert.pem /etc/ssl/private/novnc_key.pem > /etc/ssl/private/novnc_combined.pem
chmod 600 /etc/ssl/private/novnc_combined.pem

/usr/share/novnc/utils/launch.sh --listen $NOVNCPORT --vnc localhost:$VNCPORT \
  --cert /etc/ssl/private/novnc_combined.pem --ssl-only \
  > /var/log/novnc.log 2>&1 &

echo "Local folder mounted to /tmp/local_mount"
echo "Launch your web browser and open https://localhost:$NOVNCPORT/vnc.html"
echo "Verify the certificate fingerprint:"
openssl x509 -in /etc/ssl/certs/novnc_cert.pem -noout -fingerprint -sha256

# Start shell

/bin/bash