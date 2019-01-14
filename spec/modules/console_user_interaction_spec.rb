# frozen_string_literal: true

module Codebreaker
  RSpec.describe ConsoleUserInteraction do
    let(:console) { Console.new }

    describe '#options_list' do
      let(:list_of_options) { Console::COMMANDS.values.map(&:capitalize) }

      it { expect(console.options_list).to eq list_of_options }
    end

    describe '#user_input' do
      after { console.user_input }

      it 'gets user input' do
        expect(console).to receive_message_chain(:gets, :chomp, :downcase)
      end

      it 'when exit' do
        allow(console).to receive_message_chain(:gets, :chomp, :downcase).and_return(Console::COMMANDS[:exit])
        expect(console).to receive(:exit_from_console)
      end
    end

    describe '#exit from console' do
      it { expect { console.exit_from_console }.to output("#{I18n.t('message.exit')}\n").to_stdout }
      it { expect { console.exit_from_console }.to raise_error(SystemExit) }
    end
  end
end
