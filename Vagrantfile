# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://github.com/citusdata/pg_shard

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"

  # Common configuration for all boxes
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y postgresql
  SHELL

  # multiple postgresql workers
  config.vm.define "worker1" do |worker1|
    worker1.vm.network "private_network", ip: "192.168.33.11"

    worker1.vm.provision "shell", inline: <<-SHELL
      sudo -u postgres bash -c "echo 'host all all samenet trust' >> /etc/postgresql/9.4/main/pg_hba.conf"
      sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
      sudo systemctl restart postgresql
      sudo -u postgres createdb -e sample_database
    SHELL
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.network "private_network", ip: "192.168.33.12"

    worker2.vm.provision "shell", inline: <<-SHELL
      sudo -u postgres bash -c "echo 'host all all samenet trust' >> /etc/postgresql/9.4/main/pg_hba.conf"
      sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
      sudo systemctl restart postgresql
      sudo -u postgres createdb -e sample_database
    SHELL
  end

  config.vm.define "worker3" do |worker3|
    worker3.vm.network "private_network", ip: "192.168.33.13"

    worker3.vm.provision "shell", inline: <<-SHELL
      sudo -u postgres bash -c "echo 'host all all samenet trust' >> /etc/postgresql/9.4/main/pg_hba.conf"
      sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
      sudo systemctl restart postgresql
      sudo -u postgres createdb -e sample_database
    SHELL
  end

  # master postgresql
  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.33.10"

    master.vm.provision "shell", inline: <<-SHELL
      sudo apt-get install -y build-essential git postgresql-client postgresql-server-dev-all
      mkdir -p ~/tmp
      cd /tmp
      git clone https://github.com/citusdata/pg_shard.git
      cd pg_shard
      make
      sudo make install
      sudo sed -i "s/#shared_preload_libraries = ''/shared_preload_libraries = 'pg_shard'/" /etc/postgresql/9.4/main/postgresql.conf
      sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.4/main/postgresql.conf
      cat > /tmp/pg_worker_list.conf <<EOS
192.168.33.11 5432
192.168.33.12 5432
192.168.33.13 5432
EOS
      sudo -u postgres cp -v /tmp/pg_worker_list.conf /var/lib/postgresql/9.4/main/pg_worker_list.conf
      sudo systemctl restart postgresql
      sudo -u postgres createdb -e sample_database
      sudo -u postgres psql sample_database -c "create extension pg_shard;"
      # NOTE: incrementing integer user id is not a good candidate for sharding, does pg_shard do hashing on top of given key?
      sudo -u postgres psql sample_database -c "create table data (user_id integer, ts timestamp, json_data json);"
      sudo -u postgres psql sample_database -c "SELECT master_create_distributed_table('data', 'user_id');"
      # 16 shards; replication factor of 2
      sudo -u postgres psql sample_database -c "SELECT master_create_worker_shards('data', 16, 2);"
      for i in $(seq 10)
      do
        sudo -u postgres psql sample_database -c "INSERT INTO data VALUES($i, timestamp 'now', '{}');"
      done
      sudo -u postgres psql sample_database -c "SELECT * FROM pgs_distribution_metadata.shard;"
      sudo -u postgres psql sample_database -c "SELECT * FROM pgs_distribution_metadata.shard_placement;"
    SHELL
  end
end
