#
# Cookbook:: opsworks
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

template '/tmp/dns.json' do
  source 'dns.json.erb'
  mode '0644'
end
execute "enroll in DNS" do
  command "aws route53 change-resource-record-sets --hosted-zone-id #{node['dns_zone_id']} --change-batch file:///tmp/dns.json"
end

Chef::Log.info("****** DNS reconfig ******")
execute 'Configure hostname2' do
  command "echo #{node['opsworks']['instance']['hostname']}.#{node['opsworks']['stack']['name']}.#{node['domain_name']} > /etc/hostname"
  ignore_failure true
end


template '/etc/sysconfig/network' do
  source 'network.erb'
  mode '0644'
end

