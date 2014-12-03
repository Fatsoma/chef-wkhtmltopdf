require 'spec_helper'

describe command('which wkhtmltoimage') do
  it { expect(subject.exit_status).to eq 0 }
end

describe command('which wkhtmltopdf') do
  it { expect(subject.exit_status).to eq 0 }
end
