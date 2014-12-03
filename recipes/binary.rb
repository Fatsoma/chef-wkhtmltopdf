cache_dir = Chef::Config[:file_cache_path]
download_dest = File.join(cache_dir, node['wkhtmltopdf']['archive'])

remote_file download_dest do
  source node['wkhtmltopdf']['mirror_url']
  mode '0644'
  action :create_if_missing
end

package 'wkhtmltox' do
  source download_dest
  provider Chef::Provider::Package::Dpkg if node['wkhtmltopdf']['suffix'] == 'deb'
  action :install
end
