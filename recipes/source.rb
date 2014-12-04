cache_dir = Chef::Config[:file_cache_path]
download_dest = File.join(cache_dir, node['wkhtmltopdf']['archive'])
wkhtmltopdf_version = Chef::Version.new(node['wkhtmltopdf']['version'])
extracted_path = File.join(cache_dir, node['wkhtmltopdf']['extracted_name'])
static_build_path = File.join(extracted_path, 'static-build', node['wkhtmltopdf']['build_target'], "wkhtmltox-#{node['wkhtmltopdf']['version']}")

remote_file download_dest do
  source node['wkhtmltopdf']['mirror_url']
  mode '0644'
  action :create_if_missing
end

execute 'extract_wkhtmltopdf' do
  cwd cache_dir
  command "tar -xjf #{download_dest}"
  creates extracted_path
end

# Bug in build script with location to run tar from
# Fixed upstream in 0.12.2
if node['wkhtmltopdf']['version'] == '0.12.1'
  cookbook_file File.join(extracted_path, 'build_fixtar.patch') do
    source 'build_fixtar.patch'
    mode 0644
  end
  execute 'patch_wkhtmltox_build' do
    cwd extracted_path
    command 'patch -p0 < build_fixtar.patch'
  end
end

execute 'compile_wkhtmltox' do
  cwd extracted_path
  command "scripts/build.py #{node['wkhtmltopdf']['build_target']}"
  creates static_build_path
end

execute 'install_wkhtmltoimage' do
  cwd static_build_path
  command "cp bin/wkhtmltoimage #{node['wkhtmltopdf']['install_dir']}/wkhtmltoimage"
  creates "#{node['wkhtmltopdf']['install_dir']}/wkhtmltoimage"
end

execute 'install_wkhtmltopdf' do
  cwd static_build_path
  command "cp bin/wkhtmltopdf #{node['wkhtmltopdf']['install_dir']}/wkhtmltopdf"
  creates "#{node['wkhtmltopdf']['install_dir']}/wkhtmltopdf"
end

unless node['wkhtmltopdf']['lib_dir'].empty?
  execute 'install_wkhtmltox_so' do
    cwd static_build_path
    command "cp lib/libwkhtmltox.so.#{node['wkhtmltopdf']['version']} #{node['wkhtmltopdf']['lib_dir']}/libwkhtmltox.so.#{node['wkhtmltopdf']['version']}"
    creates "#{node['wkhtmltopdf']['lib_dir']}/libwkhtmltox.so.#{node['wkhtmltopdf']['version']}"
  end

  link "#{node['wkhtmltopdf']['lib_dir']}/libwkhtmltox.so.#{wkhtmltopdf_version.major}.#{wkhtmltopdf_version.minor}" do
    to "#{node['wkhtmltopdf']['lib_dir']}/libwkhtmltox.so.#{node['wkhtmltopdf']['version']}"
  end

  link "#{node['wkhtmltopdf']['lib_dir']}/libwkhtmltox.so.#{wkhtmltopdf_version.major}" do
    to "#{node['wkhtmltopdf']['lib_dir']}/libwkhtmltox.so.#{node['wkhtmltopdf']['version']}"
  end
end
