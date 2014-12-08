require 'spec_helper'

describe package('wkhtmltox'), unless: os[:family] == 'freebsd' do
  it { should be_installed.with_version('0.12.1') }
end

describe package('wkhtmltopdf'), if: os[:family] == 'freebsd' do
  it { should be_installed.with_version('0.12.1') }
end
