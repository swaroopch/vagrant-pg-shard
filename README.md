# vagrant-pg-shard

Vagrantfile to try out <https://github.com/citusdata/pg_shard>

`pg_shard` is a Postgresql extension that enables a sharded Postgresql setup.

# Installation

1. Install Vagrant from <https://www.vagrantup.com>

2. `git clone https://github.com/swaroopch/vagrant-pg-shard.git && cd vagrant-pg-shard`

3. `vagrant up`

4. You now have 1 master (with `pg_shard`) and 3 worker postgresql instances running!
