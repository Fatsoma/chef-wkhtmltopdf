cache_dir = Chef::Config[:file_cache_path]
download_dest = File.join(cache_dir, node['wkhtmltopdf']['archive'])

if node['wkhtmltopdf']['platform'] == 'linux-generic'
  wkhtmltopdf_version = Chef::Version.new(node['wkhtmltopdf']['version'])

  ark 'wkhtmltopdf' do
    url node['wkhtmltopdf']['mirror_url']
    version node['wkhtmltopdf']['version']
  end

  %w(wkhtmltopdf wkhtmltoimage).each do |binary_name|
    link File.join(node['wkhtmltopdf']['install_dir'], binary_name) do
      to File.join(node['ark']['prefix_root'], 'wkhtmltopdf', 'bin', binary_name)
    end
  end

  unless node['wkhtmltopdf']['lib_dir'].empty?
    link File.join(node['wkhtmltopdf']['lib_dir'], "libwkhtmltox.so.#{node['wkhtmltopdf']['version']}") do
      to File.join(node['ark']['prefix_root'], 'wkhtmltopdf', 'lib', "libwkhtmltox.so.#{node['wkhtmltopdf']['version']}")
    end
    link File.join(node['wkhtmltopdf']['lib_dir'], "libwkhtmltox.so.#{wkhtmltopdf_version.major}.#{wkhtmltopdf_version.minor}") do
      to File.join(node['wkhtmltopdf']['lib_dir'], "libwkhtmltox.so.#{node['wkhtmltopdf']['version']}")
    end
    link File.join(node['wkhtmltopdf']['lib_dir'], "libwkhtmltox.so.#{wkhtmltopdf_version.major}") do
      to File.join(node['wkhtmltopdf']['lib_dir'], "libwkhtmltox.so.#{node['wkhtmltopdf']['version']}")
    end
    link File.join(node['wkhtmltopdf']['lib_dir'], 'libwkhtmltox.so') do
      to File.join(node['wkhtmltopdf']['lib_dir'], "libwkhtmltox.so.#{node['wkhtmltopdf']['version']}")
    end
  end
else
  remote_file download_dest do
    source node['wkhtmltopdf']['mirror_url']
    mode '0644'
    action :create_if_missing
    not_if { node['platform_family'] == 'freebsd' }
  end

  case node['platform_family']
  when 'mac_os_x', 'mac_os_x_server'
    execute 'install_wkhtmltox' do
      command "installer -pkg #{download_dest} -target /"
    end
  when 'windows'
    execute 'install_wkhtmltox' do
      command download_dest
    end
  when 'debian'
    dpkg_package 'wkhtmltox' do
      source download_dest
    end
  when 'rhel', 'fedora'
    rpm_package 'wkhtmltox' do
      source download_dest
    end
  when 'freebsd'
    # Force support pkgng as it seems to check before freebsd::pkgng is run
    Chef::Resource::FreebsdPackage.class_eval do
      def supports_pkgng?
        true
      end
    end
    package 'wkhtmltopdf' do
      version node['wkhtmltopdf']['version']
    end
  end
end
