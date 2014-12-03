require 'spec_helper'

describe 'wkhtmltopdf::binary' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  let(:cache_dir) { Chef::Config[:file_cache_path] }
  let(:version) { '0.12.1' }
  let(:platform) { 'linux-precise' }
  let(:architecture) { 'amd64' }
  let(:suffix) { 'deb' }
  let(:archive) { "wkhtmltox-#{version}_#{platform}-#{architecture}.#{suffix}" }
  let(:download_dest) { File.join(cache_dir, archive) }

  it { expect(chef_run).to create_remote_file_if_missing(download_dest) }
  it { expect(chef_run).to install_package('wkhtmltox') }
end
