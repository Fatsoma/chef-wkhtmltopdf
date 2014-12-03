require 'spec_helper'

describe command('which wkhtmltoimage') do
  describe '#exit_status' do
    subject { super().exit_status }
    it { expect(subject.exit_status).to eq 0 }
  end
end

describe command('which wkhtmltopdf') do
  describe '#exit_status' do
    subject { super().exit_status }
    it { expect(subject.exit_status).to eq 0 }
  end
end
