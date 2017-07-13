require 'spec_helper'

describe 'wkhtmltopdf::binary' do
  context 'with linux-generic package' do
    let(:version) { '0.12.4' } # any version >= 0.12.3
    let(:archive) { "wkhtmltox-#{version}_#{platform}-#{architecture}.#{suffix}" }
    let(:mirror_url) { "https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/#{version}/#{archive}" }

    let(:platform) { 'linux-generic' }
    let(:architecture) { 'amd64' }
    let(:suffix) { 'tar.xz' }

    let(:lib_dir) { '/usr/local/lib' }
    let(:home_dir) { '/usr/local/wkhtmltopdf' }

    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['wkhtmltopdf']['version'] = version
        node.set['wkhtmltopdf']['lib_dir'] = lib_dir
      end.converge(described_recipe)
    end

    it do
      expect(chef_run).to install_ark('wkhtmltopdf')
        .with_url(mirror_url)
        .with_version(version)
    end

    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.#{version}")
        .with_to("#{home_dir}/lib/libwkhtmltox.so.#{version}")
    end
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.0.12")
        .with_to("#{lib_dir}/libwkhtmltox.so.#{version}")
    end
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so.0")
        .with_to("#{lib_dir}/libwkhtmltox.so.#{version}")
    end
    it do
      expect(chef_run).to create_link("#{lib_dir}/libwkhtmltox.so")
        .with_to("#{lib_dir}/libwkhtmltox.so.#{version}")
    end
  end

  context 'with distribution specific packages' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['wkhtmltopdf']['version'] = version
      end.converge(described_recipe)
    end

    let(:cache_dir) { Chef::Config[:file_cache_path] }
    let(:version) { '0.12.1' }
    let(:archive) { "wkhtmltox-#{version}_#{platform}-#{architecture}.#{suffix}" }
    let(:download_dest) { File.join(cache_dir, archive) }

    context 'for ubuntu' do
      let(:platform) { 'linux-precise' }
      let(:architecture) { 'amd64' }
      let(:suffix) { 'deb' }

      it { expect(chef_run).to create_remote_file_if_missing(download_dest) }

      it do
        expect(chef_run).to install_dpkg_package('wkhtmltox')
          .with_source(download_dest)
      end
    end

    context 'for centos' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5') do |node|
          node.set['wkhtmltopdf']['version'] = version
        end.converge(described_recipe)
      end

      let(:platform) { 'linux-centos6' }
      let(:architecture) { 'amd64' }
      let(:suffix) { 'rpm' }

      it { expect(chef_run).to create_remote_file_if_missing(download_dest) }

      it do
        expect(chef_run).to install_rpm_package('wkhtmltox')
          .with_source(download_dest)
      end
    end

    context 'for freebsd' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'freebsd', version: '9.2') do |node|
          node.set['wkhtmltopdf']['version'] = version
        end.converge(described_recipe)
      end

      it do
        expect(chef_run).to install_package('wkhtmltopdf')
          .with_version(version)
      end
    end
  end
end
