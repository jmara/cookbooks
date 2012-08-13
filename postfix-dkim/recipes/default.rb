#
# Cookbook Name:: postfix-dkim
# Recipe:: default
#
# Copyright 2011, Room 118 Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node.platform
when "debian", "ubuntu"

if node['lsb']['codename'] = 'precise'
then
 package 'opendkim'
 dkim_config  = "/etc/opendkim.conf"
 dkim_default = "/etc/default/opendkim"
 dkim_genkey  = "opendkim-genkey"
else
 package 'dkim-filter'
 dkim_config  = "/etc/dkim-filter.conf"
 dkim_default = "/etc/default/dkim-filter"
 dkim_genkey  = "dkim-genkey"
fi

template "#{dkim_config}" do
  source "dkim-filter.conf.erb"
  mode 0755
end

template "#{dkim_default}" do
  source "dkim-filter.erb"
  mode 0755
end

directory node[:postfix_dkim][:dir] do
  mode 0755
end

bash "generate and install key" do
  cwd node[:postfix_dkim][:dir]
  code <<-EOH
    if [ ! -e "#{node[:postfix_dkim][:keyfile]}" ]
    then
      #{dkim_genkey} #{node[:postfix_dkim][:testmode] ? '-t' : ''} -s #{node[:postfix_dkim][:selector]} -d #{node[:postfix_dkim][:domain]}
      mv "#{node[:postfix_dkim][:selector]}.private" #{node[:postfix_dkim][:dir]}
    fi
  EOH
end

if node['lsb']['codename'] = 'precise'
then
 service "opendkim" do
   action :start
 end
else
 service "dkim-filter" do
   action :start
 end
fi

service "postfix" do
  action :restart
end

end
