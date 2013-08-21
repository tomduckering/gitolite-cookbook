#
# Cookbook Name:: gitolite
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

username = 'git'
groupname = 'git'

user username do
  home '/home/git'
end

include_recipe 'git'
include_recipe 'git::server'

directory '/home/git/bin' do
  owner username
  group groupname
  mode 0755
end

directory node['gitolite']['repo_base'] do
  owner username
  group groupname
  mode 0755
end

link '/home/git/repositories' do
  owner username
  group groupname
  mode 0755
  to node['gitolite']['repo_base']
end

#TODO - replace with fetching gitolite from github.
cookbook_file '/tmp/gitolite-3.5.2.tar.gz' do
  source 'gitolite-3.5.2.tar.gz'
  owner username
  group groupname
end

execute 'unpack gitolite' do
  command 'tar xzf /tmp/gitolite-3.5.2.tar.gz && chmod -R u+rwX,go+rX,go-w /home/git/gitolite && chmod 0755 /home/git/gitolite/src/gitolite'
  cwd '/home/git'
  creates '/home/git/gitolite'
  user username
  group groupname
end

package 'perl-Time-HiRes'

execute 'install gitolite' do
  environment ({ "HOME" => "/home/git" })
  command '/home/git/gitolite/install -ln /home/git/bin'
  creates '/home/git/bin/gitolite'
  user username
  group groupname
end


#TODO - replace with pub key data from attribute.
cookbook_file '/tmp/gitolite_admin.pub' do
  source 'gitolite_admin.pub'
  owner username
  group groupname
end

execute 'setup gitolite' do
  user username
  group groupname
  environment ({ "HOME" => "/home/git" }) #required because perl can't tell that we're running as gitolite user.
  command '/home/git/bin/gitolite setup -pk /tmp/gitolite_admin.pub'
end


