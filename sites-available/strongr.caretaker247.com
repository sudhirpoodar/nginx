server {
 listen 80;
 listen [::]:80;
 server_name strongr.caretaker247.com;
 return 301 https://$host$request_uri;

}

server {
    listen [::]:443 ssl;
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/strongr.caretaker247.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/strongr.caretaker247.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    
    server_name strongr.caretaker247.com;
    root /var/www/html/strong;
    index index.html;

  location ^~ /ws {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_pass http://127.0.0.1:8546/;
  }

  location ^~ /rpc {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_pass http://127.0.0.1:8545/;
  }
    location / {
    auth_basic           "Adminstrator Area";
    auth_basic_user_file /etc/nginx/.htpasswd;
}
}
