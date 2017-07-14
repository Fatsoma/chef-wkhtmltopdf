name 'wkhtmltopdf'
maintainer 'Bill Ruddock'
maintainer_email 'bill.ruddock@fatsoma.com'
license 'Apache 2.0'
description 'Installs wkhtmltoimage and wkhtmltopdf'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.4.0'

recipe 'wkhtmltopdf', 'Installs wkhtmltoimage and wkhtmltopdf'
recipe 'wkhtmltopdf::binary', 'Installs wkhtmltoimage and wkhtmltopdf binaries'
recipe 'wkhtmltopdf::source', 'Installs wkhtmltoimage and wkhtmltopdf from source'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'redhat'
supports 'ubuntu'

depends 'apt'
depends 'freebsd'
depends 'ark'

source_url 'https://github.com/Fatsoma/chef-wkhtmltopdf' if respond_to?(:source_url)
issues_url 'https://github.com/Fatsoma/chef-wkhtmltopdf/issues' if respond_to?(:issues_url)

chef_version '>= 11.0' if respond_to?(:chef_version)
