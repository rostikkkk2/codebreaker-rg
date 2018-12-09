# require 'simplecow'
# SimpleCov.start do
#   add_filter /test/
#   minimum_coverage 80
# end

require './autoload'

RSpec.describe Console do
  let(:subject) { described_class.new }

  # describe '.new' do
  #   it do
  #     # expect {subject.check_option}.to receive()
  #   end
    # it { expect { subject }.to output(check_option).to_stdout }
  # end
  #
  describe '#check_option' do
    context 'rules' do
      it do
        expect { subject }.to output(hello_message).to_stdout
        allow(subject).to receive(:option).and_return('rules')
        expect(subject).to receive(:show_rules)
        subject.check_option
      end
    end
  end

  end
