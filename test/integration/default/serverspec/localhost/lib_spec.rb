require 'spec_helper'

case os[:family]
when 'debian', 'ubuntu', 'rhel', 'fedora'
  describe 'libraries' do
    lib_dir = '/usr/local/lib'
    version = '0.12.4'

    describe file("#{lib_dir}/libwkhtmltox.so.#{version}") do
      it { should be_file }
    end

    describe file("#{lib_dir}/libwkhtmltox.so.0.12") do
      it { should be_symlink }
      it { should be_linked_to "#{lib_dir}/libwkhtmltox.so.#{version}" }
    end

    describe file("#{lib_dir}/libwkhtmltox.so.0") do
      it { should be_symlink }
      it { should be_linked_to "#{lib_dir}/libwkhtmltox.so.#{version}" }
    end

    describe file("#{lib_dir}/libwkhtmltox.so") do
      it { should be_symlink }
      it { should be_linked_to "#{lib_dir}/libwkhtmltox.so.#{version}" }
    end
  end
end
