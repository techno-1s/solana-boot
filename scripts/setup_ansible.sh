sudo apt update
sudo apt install ansible-core -y
sudo apt install -y python3 python3-pip python3-venv
python3 -m venv .venv

sudo sed -i 's/^\s*#\?\s*PasswordAuthentication .*/#PasswordAuthentication no/' /etc/ssh/sshd_config && sudo systemctl reload ssh

# doublezero repository
curl -1sLf https://dl.cloudsmith.io/public/malbeclabs/doublezero/setup.deb.sh | sudo -E bash
