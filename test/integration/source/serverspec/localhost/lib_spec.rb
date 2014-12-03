require 'spec_helper'

describe 'libraries' do
  let(:lib_dir) { '/usr/local/lib' }
  let(:version) { '0.12.1' }

  describe file("#{lib_dir}/wkhtmltox.so.#{version}") do
    it { is_expected.to be_file }
  end

  describe file("#{lib_dir}/wkhtmltox.so.0.12") do
    it { is_expected.to be_symlink }
    it { is_expected.to be_linked_to "#{lib_dir}/wkhtmltox.so.#{version}" }
  end

  describe file("#{lib_dir}/wkhtmltox.so.0") do
    it { is_expected.to be_symlink }
    it { is_expected.to be_linked_to "#{lib_dir}/wkhtmltox.so.#{version}" }
  end
end
