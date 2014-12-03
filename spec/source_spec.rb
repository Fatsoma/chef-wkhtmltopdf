require 'spec_helper'

describe 'wkhtmltopdf::source' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['wkhtmltopdf']['install_method'] = 'source'
      node.set['wkhtmltopdf']['install_dir'] = install_dir
    end.converge(described_recipe)
  end

  let(:cache_dir) { Chef::Config[:file_cache_path] }
  let(:archive) { 'wkhtmltox-0.12.1.tar.bz2' }
  let(:download_dest) { File.join(cache_dir, archive) }
  let(:install_dir) { '/test/bin' }

  it { expect(chef_run).to create_remote_file_if_missing(download_dest) }
  it 'extracts archive' do
    expect(chef_run).to run_execute('extract_wkhtmltopdf')
      .with_cwd(cache_dir)
      .with_command("tar -xjf #{download_dest}")
  end
  it 'compiles wkhtmltox' do
    expect(chef_run).to run_execute('compile_wkhtmltox')
      .with_cwd("#{cache_dir}/wkhtmltox")
      .with_command('make')
  end
  it 'installs wkhtmltoimage' do
    expect(chef_run).to run_execute('install_wkhtmltoimage')
      .with_cwd(cache_dir)
      .with_command("cp wkhtmltox/bin/wkhtmltoimage #{install_dir}/wkhtmltoimage")
  end
  it 'installs wkhtmltopdf' do
    expect(chef_run).to run_execute('install_wkhtmltopdf')
      .with_cwd(cache_dir)
      .with_command("cp wkhtmltox/bin/wkhtmltopdf #{install_dir}/wkhtmltopdf")
  end

  context 'with lib_dir' do
    let(:lib_dir) { '/usr/local/lib' }
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['wkhtmltopdf']['install_method'] = 'source'
        node.set['wkhtmltopdf']['lib_dir'] = lib_dir
      end.converge(described_recipe)
    end

    it { expect(chef_run).to run_execute('install_wkhtmltox_so') }
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.0.12")
        .with_to("#{lib_dir}/libwkhtmltox.so.0.12.1")
    end
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.0")
        .with_to("#{lib_dir}/libwkhtmltox.so.0.12.1")
    end
  end
end