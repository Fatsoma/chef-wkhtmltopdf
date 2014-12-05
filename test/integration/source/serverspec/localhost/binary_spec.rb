require 'spec_helper'

describe command('which wkhtmltoimage') do
  describe '#exit_status' do
    it { expect(subject.exit_status).to eq 0 }
  end
end

describe command('which wkhtmltopdf') do
  describe '#exit_status' do
    it { expect(subject.exit_status).to eq 0 }
  end
end
