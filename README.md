# Basic Nginx Configuration
sudo apt-get update
sudo apt-get install nginx

#Lets encrypt SSL certifcation.
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx
sudo certbot --server https://acme-v02.api.letsencrypt.org/directory -d *.caretaker247.com --manual --preferred-challenges dns-01 certonly

