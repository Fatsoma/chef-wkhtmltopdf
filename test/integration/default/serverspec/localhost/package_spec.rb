require 'spec_helper'

describe package('wkhtmltox') do
  it { should be_installed.with_version('0.12.1') }
end
