require 'spec_helper'

describe 'wkhtmltopdf::default' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  let(:install_method) { 'binary' }

  context 'for ubuntu' do
    it { expect(chef_run).to include_recipe('apt') }
    it { expect(chef_run).to_not include_recipe('freebsd::pkgng') }
    it { expect(chef_run).to include_recipe("wkhtmltopdf::#{install_method}") }

    jpeg_package = 'libjpeg8'
    dependency_packages = %W(fontconfig libfontconfig1 libfreetype6 libpng12-0 zlib1g #{jpeg_package} libssl1.0.0 libx11-6 libxext6 libxrender1 libstdc++6 libc6)
    dependency_packages.each do |pkg|
      it { expect(chef_run).to install_package(pkg) }
    end
  end

  context 'for centos' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
                          .converge(described_recipe)
    end

    it { expect(chef_run).to_not include_recipe('apt') }
    it { expect(chef_run).to_not include_recipe('freebsd::pkgng') }
    it { expect(chef_run).to include_recipe("wkhtmltopdf::#{install_method}") }

    jpeg_package = 'libjpeg'
    archive_packages = %w(xz)
    dependency_packages = %W(fontconfig freetype libpng zlib #{jpeg_package} openssl libX11 libXext libXrender libstdc++ glibc)
    dependency_packages.each do |pkg|
      it { expect(chef_run).to install_package(pkg) }
    end
    archive_packages.each do |pkg|
      it { expcet(chef_run).to install_package(pkg) }
    end
  end

  context 'for freebsd' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'freebsd', version: '9.2')
                          .converge(described_recipe)
    end

    before do
      stub_command('pkg -N').and_return(true)
    end

    it { expect(chef_run).to_not include_recipe('apt') }
    it { expect(chef_run).to include_recipe('freebsd::pkgng') }
    it { expect(chef_run).to include_recipe("wkhtmltopdf::#{install_method}") }

    dependency_packages = %w(fontconfig freetype2 jpeg png libiconv libX11 libXext libXrender)
    dependency_packages.each do |pkg|
      it { expect(chef_run).to install_package(pkg) }
    end
  end
end
