require 'rspec'
require './autoload'

RSpec.describe Console do
  let(:console) { Console.new }
  let(:game) { Game.new }
  let(:guess_code) {'1111'}
  let(:secret_code) {[2,2,2,2]}

  describe '.new' do
    it { expect(console.instance_variable_get(:@info_difficult)).to eq(nil) }
  end

  context 'navigation' do
    after { console.check_option }

    describe '#check_option' do
      before { allow(console).to receive(:registration) }

      it 'calling method registration' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:start])
        expect(console).to receive(:registration)
      end

      it 'calling method rules' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:rules], Console::OPTIONS[:start])
        expect(console).to receive(:show_rules)
      end

      it 'calling method show_stats' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:stats], Console::OPTIONS[:start])
        expect(console).to receive(:show_stats)
      end

      it 'exit from game' do
        allow(console).to receive(:gets).and_return(Console::OPTIONS[:exit])
        allow(console).to receive(:show_info).with(:welcome_and_option)
        expect(console).to receive(:show_info).with(:goodbye)
      end

      it 'when invalid' do
        allow(console).to receive(:gets).and_return('', Console::OPTIONS[:start])
        allow(console).to receive(:show_info).with(:welcome_and_option)
        expect(console).to receive(:show_info).with(:wrong_input_option)
      end
    end

    it 'choose_name_and_difficulty' do
      allow(console).to receive(:gets).and_return('start', 'Rostiiik', 'Easy')
      expect(console).to receive(:show_info).with(:welcome_and_option)
      expect(console).to receive(:show_info).with(:write_name)
      expect(console).to receive(:show_info).with(:message_choose_difficulty)
      expect(console).to receive(:play_game)
    end

    it 'give error after enter name and difficulty' do
      allow(console).to receive(:gets).and_return('start', '', 'Rositk', '', 'Easy')
      expect(console).to receive(:show_info).with(:welcome_and_option)
      expect(console).to receive(:show_info).with(:write_name).twice
      expect(console).to receive(:show_info).with(:unexpected_command).twice
      expect(console).to receive(:show_info).with(:message_choose_difficulty).twice
      expect(console).to receive(:play_game)
    end
  end

  describe '#play_game' do
    after {console.play_game}

    it 'ask guess and show hint' do
      allow(console).to receive(:gets).and_return('Hint', 'exit')
      allow(console).to receive(:check_hint)
    end

  end


   # describe '#show_stats' do
   #   after {console.show_stats}
   #
   #   it 'show stats' do
   #     console.send(:show_stats)
   #   end
   # end
   #
   # describe '#show_rules' do
   #   after {console.show_rules}
   #
   #   it 'show rules' do
   #     expect(console).to receive(:show_info).with(:rules)
   #   end
   # end

   # describe '#check_win' do
   #   # after {console.check_win}
   #   it do
   #     allow(console.check_win).with('++++').to eq(true)
   #   end
   # end
   #

  # describe '#show_hint' do
  #   it 'show number of hints' do
  #     expect{ console.show_hint }.to change { console.instance_variable_get(:@user[:hints_used]) }.by(+1)
  #   end
  # end
  #
  # describe '#check_win' do
  #   it 'is win' do
  #     # expect(console.check_win).with('++++').to eq(true)
  #     # expect(console.check_win).to receive(:check_win).with('++++').and_return(true)
  #     console.check_win('++++')
  #     # expect(console.win).to eq(nil)
  #     # console.send(:win)
  #
  #   end
  # end

   #
   # describe '#win' do
   #   after {console.win}
   #
   #   it do
   #     # ???????????????????????????????????
   #     expect(console).to receive(:show_info_without_i18).with(:@secret_code)
   #     expect(console).to receive(:save)
   #     expect(console).to receive(:restart?)
   #   end
   # end



end
