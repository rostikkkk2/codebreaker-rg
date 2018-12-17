RSpec.describe Db do
  let(:db) { described_class.new }
  let(:test_user) { { name: 'Test', difficulty: 'Easy', attempts_total: 15, attempts_used: 2, hints_total: 2, hints_used: 0 } }

  describe '#add_data_to_db' do
    it do
      subject.add_data_to_db(test_user)
    end
  end
end
