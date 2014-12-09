include_recipe 'apt' if node['platform_family'] == 'debian'
if node['platform_family'] == 'freebsd'
  if node['platform_version'].to_f >= 10.0
    include_recipe 'freebsd::pkgng'
  else
    include_recipe 'freebsd::portsnap'
  end
end

node['wkhtmltopdf']['dependency_packages'].each do |p|
  package p
end

include_recipe "wkhtmltopdf::#{node['wkhtmltopdf']['install_method']}"
