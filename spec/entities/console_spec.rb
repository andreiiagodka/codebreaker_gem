# frozen_string_literal: true

module Codebreaker
  RSpec.describe Console do
    let(:difficulty_double) { instance_double('Difficulty', level: Difficulty::DIFFICULTIES[random_difficulty]) }

    let(:random_difficulty) { Difficulty::DIFFICULTIES.keys.sample }

    describe '#new' do
      it { expect(subject.output).to be_an_instance_of(Output) }
      it { expect(subject.failing).to be_an_instance_of(Failing) }
      it { expect(subject.statistic).to be_an_instance_of(Statistic) }
    end

    describe '#menu' do
      let(:list_of_options) { subject.options_list.join("\n") }

      before do
        allow(subject).to receive(:select_option)
        allow(subject).to receive(:loop).and_yield
      end

      it 'outputs introduction message and list of options' do
        expect { subject.menu }.to output("#{I18n.t('message.introduction')}\n#{list_of_options}\n").to_stdout
      end
    end

    describe '#select_option' do
      let(:statistic) { Statistic.new }
      let(:invalid_command) { Console::COMMANDS.keys }

      before { allow(subject).to receive(:navigation) }

      it 'when command #start' do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:start])
        expect(subject).to receive(:navigation)
        subject.select_option
      end

      it 'when command #rules' do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:rules])
        expect { subject.select_option }.to output("#{I18n.t('message.rules')}\n").to_stdout
      end

      it 'when command #stats' do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:stats])
        expect { subject.select_option }.to output("#{statistic.rating_table}\n").to_stdout
      end

      it 'when command is invalid' do
        allow(subject).to receive(:user_input).and_return(invalid_command)
        expect { subject.select_option }.to output("#{I18n.t('error.unexpected_option')}\n").to_stdout
      end
    end

    describe '#navigation' do
      before do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:start])
        allow(subject).to receive(:game_process)
      end

      it 'calls methods which create Player and Difficulty instances' do
        expect(subject).to receive(:create_entity).with(Player)
        expect(subject).to receive(:create_entity).with(Difficulty)
        subject.select_option
      end
    end

    describe '#game_process' do
      before do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:start], difficulty_double.level[:level])
        allow(subject).to receive(:make_guess)
        subject.instance_variable_set(:@difficulty, difficulty_double)
      end

      it 'outputs game start message' do
        expect { subject.send(:game_process) }.to output("#{I18n.t('message.game_start_heading')}\n").to_stdout
        subject.select_option
      end

      it 'creates Game instance' do
        expect(Game).to receive(:new).with(difficulty_double.level)
        subject.select_option
      end
    end

    describe '#make_guess' do
      before do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:start], difficulty_double.level[:level])
        allow(subject).to receive(:loop).and_yield
      end

      it 'outputs hint' do
        expect(subject.instance_variable_get(:@guess)).to receive(:hint?).and_return(true)
        expect(subject).to receive(:output_hint)
        subject.select_option
      end

      it 'outputs guess result' do
        expect(subject.instance_variable_get(:@guess)).to receive(:hint?)
        expect(subject).to receive(:guess_result)
        subject.select_option
      end
    end

    describe '#output_hint' do
      before do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:start], difficulty_double.level[:level])
        allow(subject).to receive(:loop).and_yield
        allow(subject.instance_variable_get(:@guess)).to receive(:hint?)
        allow(subject).to receive(:guess_result)
      end

      it 'outputs hints limit message' do
        allow(subject.instance_variable_get(:@game)).to receive(:hints_available?).and_return(true)
        expect { subject.send(:output_hint) }.to output("#{I18n.t('error.hints_limit')}\n").to_stdout
        subject.select_option
      end

      it 'outputs hint' do
        allow(subject.instance_variable_get(:@game)).to receive(:hints_available?)
        allow(subject.instance_variable_get(:@game)).to receive(:use_hint)
        expect { subject.send(:output_hint) }.to output("#{@game.use_hint}\n").to_stdout
        subject.select_option
      end
    end

    describe '#loss' do
      before do
        allow(subject).to receive(:user_input).and_return(Console::COMMANDS[:start], difficulty_double.level[:level])
        allow(subject).to receive(:loop).and_yield
        allow(subject.instance_variable_get(:@guess)).to receive(:hint?)
        allow(subject).to receive(:guess_result)
        allow(subject).to receive(:start_new_game)
      end

      it 'outputs hints limit message' do
        expect { subject.send(:loss) }.to output("#{I18n.t('error.attempts_limit')}\n").to_stdout
        subject.select_option
      end
    end
  end
end
