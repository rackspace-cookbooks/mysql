require 'spec_helper'

describe 'rackspace_mysql::_server_rhel.rb' do
  let(:centos6_run) { ChefSpec::Runner.new(platform: 'centos', version: '6.4').converge(described_recipe) }
end

describe 'rackspace_mysql::server' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['rackspace_mysql']['server_debian_password'] = 'idontlikerandompasswords'
      node.set['rackspace_mysql']['server_root_password'] = 'idontlikerandompasswords'
      node.set['rackspace_mysql']['server_repl_password'] = 'idontlikerandompasswords'
    end.converge(described_recipe)
  end
  it 'include the default recipe' do
    expect(chef_run).to include_recipe 'rackspace_mysql::_server_debian'
  end
  it 'populate the /var/cache/local/preseeding directory' do
    expect(chef_run).to create_directory('/var/cache/local/preseeding')
  end
  it 'populate the /var/run/mysqld directory' do
    expect(chef_run).to create_directory('/var/run/mysqld')
  end
  it 'populate the /var/lib/mysqltmp directory' do
    expect(chef_run).to create_directory('/var/lib/mysqltmp')
  end
  it 'populate the /etc/mysql/conf.d directory' do
    expect(chef_run).to create_directory('/etc/mysql/conf.d')
  end
  it 'populate the /var/lib/mysql directory' do
    expect(chef_run).to create_directory('/var/lib/mysql')
  end
  it 'template mysql-server.seed is created' do
    expect(chef_run).to create_template '/var/cache/local/preseeding/mysql-server.seed'
  end
  it 'template /etc/mysql/debian.cnf is created' do
    expect(chef_run).to create_template '/etc/mysql/debian.cnf'
  end
  it 'template /etc/init/mysql.conf is created' do
    expect(chef_run).to create_template '/etc/init/mysql.conf'
  end
  it 'template /etc/apparmor.d/usr.sbin.mysqld is created' do
    expect(chef_run).to create_template '/etc/apparmor.d/usr.sbin.mysqld'
  end
  it 'installs package mysql-server' do
    expect(chef_run).to install_package('mysql-server')
  end
  it 'installs package apparmor-utils' do
    expect(chef_run).to install_package('apparmor-utils')
  end
end
