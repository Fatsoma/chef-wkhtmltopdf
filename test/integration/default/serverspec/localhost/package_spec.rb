require 'spec_helper'

describe 'package' do
  version = '0.12.4'

  case os[:family]
  when 'freebsd'
    describe package('wkhtmltopdf'), if: os[:release].to_f >= 10.0 do
      it { should be_installed.with_version(version) }
    end

    describe command('pkg query %v wkhtmltopdf'), if: os[:release].to_f < 10.0 do
      its(:stdout) { should match(/\b#{Regexp.escape(version)}(?:_.*)?\b/) }
      its(:exit_status) { should eq(0) }
    end
  end
end
