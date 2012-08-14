#
# Cookbook Name:: postfix
# Recipe:: default
#
 
 package "postfix" do
   action :upgrade
 end

 template "/etc/postfix/main.cf" do
   source "main.cf.erb"
   mode  0644
   user  "root"
   group "root"
   notifies :restart, "service[postfix]", :immediately
 end

 service "postfix" do
   action [:enable]
   supports :restart => true, :reload => true
 end
