# RSpec.describe Game do
#   let(:agree_command) { 'yes' }
#
#   describe '#compare_guess_and_secret_codes' do
#     [
#       [[6, 5, 4, 1], '6541', '++++'],
#       [[1, 2, 3, 4], '5612', '--'],
#       [[5, 5, 6, 6], '5600', '+-'],
#       [[6, 2, 3, 5], '2365', '+---'],
#       [[1, 2, 3, 4], '4321', '----'],
#       [[1, 2, 3, 4], '1235', '+++'],
#       [[1, 2, 3, 4], '6254', '++'],
#       [[1, 2, 3, 4], '5635', '+'],
#       [[1, 2, 3, 4], '4326', '---'],
#       [[1, 2, 3, 4], '3525', '--'],
#       [[1, 2, 3, 4], '2552', '-'],
#       [[1, 2, 3, 4], '4255', '+-'],
#       [[1, 2, 3, 4], '1524', '++-'],
#       [[1, 2, 3, 4], '5431', '+--'],
#       [[1, 2, 3, 4], '2134', '++--'],
#       [[1, 2, 3, 4], '6666', '']
#     ].each do |item|
#       it "return #{item[2]} if code is - #{item[0]}, guess_code is #{item[1]}" do
#         subject.instance_variable_set(:@secret_code, item[0])
#         expect(subject.compare_guess_and_secret_codes(item[1])).to eq item[2]
#       end
#     end
#   end
#
#   describe '#restart' do
#     it 'go to restart' do
#       allow_any_instance_of(Console).to receive(:show_message_and_input).and_return(agree_command)
#       allow_any_instance_of(Console).to receive(:check_option)
#       Console.new.send(:ask_restart)
#     end
#   end
# end
