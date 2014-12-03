default['wkhtmltopdf']['version']        = '0.12.1'
default['wkhtmltopdf']['install_method'] = 'binary'
default['wkhtmltopdf']['install_dir']    = '/usr/local/bin'
default['wkhtmltopdf']['lib_dir']        = ''

case node['platform_family']
when 'mac_os_x', 'mac_os_x_server'
  default['wkhtmltopdf']['dependency_packages'] = []
  default['wkhtmltopdf']['suffix'] = 'pkg'
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['platform'] = 'osx-cocoa'
    default['wkhtmltopdf']['architecture'] = 'x86_64'
  else
    default['wkhtmltopdf']['platform'] = 'osx-carbon'
    default['wkhtmltopdf']['architecture'] = 'i386'
  end

when 'windows'
  default['wkhtmltopdf']['dependency_packages'] = []
  default['wkhtmltopdf']['suffix'] = 'exe'
  default['wkhtmltopdf']['platform'] = 'mingw-w64-cross'
  # or default['wkhtmltopdf']['platform'] = 'msvc2013'
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['architecture'] = 'win64'
  else
    default['wkhtmltopdf']['architecture'] = 'win32'
  end

when 'debian'
  jpeg_package = 'libjpeg8'
  platform_version = node['platform_version']
  default['wkhtmltopdf']['suffix'] = 'deb'
  if platform?('debian')
    default['wkhtmltopdf']['platform'] = 'linux-wheezy'
  elsif platform?('ubuntu')
    if Chef::VersionConstraint.new('>= 14.04').include?(platform_version)
      jpeg_package = 'libjpeg-turbo8'
      default['wkhtmltopdf']['platform'] = 'linux-trusty'
    elsif Chef::VersionConstraint.new('>= 12.04').include?(platform_version)
      default['wkhtmltopdf']['platform'] = 'linux-precise'
    end
  end
  default['wkhtmltopdf']['dependency_packages'] = %W(fontconfig libfontconfig1 libfreetype6 libpng12-0 zlib1g #{jpeg_package} libssl1.0.0 libx11-6 libxext6 libxrender1 libstdc++6 libc6)
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['architecture'] = 'amd64'
  else
    default['wkhtmltopdf']['architecture'] = 'i386'
  end

when 'rhel'
  jpeg_package = 'libjpeg'
  default['wkhtmltopdf']['suffix'] = 'rpm'
  if Chef::VersionConstraint.new('>= 7.0').include?(node['platform_version'])
    if node['kernel']['machine'] == 'x86_64'
      jpeg_package = 'libjpeg-turbo'
      default['wkhtmltopdf']['platform'] = 'linux-centos7'
    else
      default['wkhtmltopdf']['platform'] = 'linux-centos6'
    end
  elsif Chef::VersionConstraint.new('>= 6.0').include?(node['platform_version'])
    default['wkhtmltopdf']['platform'] = 'linux-centos6'
  else
    default['wkhtmltopdf']['platform'] = 'linux-centos5'
  end
  default['wkhtmltopdf']['dependency_packages'] = %W(fontconfig freetype libpng zlib #{jpeg_package} openssl libX11 libXext libXrender libstdc++ glibc)
  if node['kernel']['machine'] == 'x86_64'
    default['wkhtmltopdf']['architecture'] = 'amd64'
  else
    default['wkhtmltopdf']['architecture'] = 'i386'
  end

else
  default['wkhtmltopdf']['install_method'] = 'source'
end

if node['wkhtmltopdf']['install_method'] == 'source'
  default['wkhtmltopdf']['dependency_packages'] = []
  default['wkhtmltopdf']['suffix'] = 'tar.bz2'
  default['wkhtmltopdf']['platform'] = ''
  default['wkhtmltopdf']['architecture'] = ''
  default['wkhtmltopdf']['archive'] = "wkhtmltox-#{node['wkhtmltopdf']['version']}.#{node['wkhtmltopdf']['suffix']}"
else
  default['wkhtmltopdf']['archive'] = "wkhtmltox-#{node['wkhtmltopdf']['version']}_#{node['wkhtmltopdf']['platform']}-#{node['wkhtmltopdf']['architecture']}.#{node['wkhtmltopdf']['suffix']}"
end

default['wkhtmltopdf']['mirror_url'] = "http://downloads.sourceforge.net/project/wkhtmltopdf/#{node['wkhtmltopdf']['version']}/#{node['wkhtmltopdf']['archive']}"
