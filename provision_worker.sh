sudo apt-get update
sudo apt-get install -y postgresql
sudo -u postgres bash -c "echo 'host all all samenet trust' >> /etc/postgresql/9.4/main/pg_hba.conf"
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
sudo systemctl restart postgresql
sudo -u postgres createdb -e sample_database
