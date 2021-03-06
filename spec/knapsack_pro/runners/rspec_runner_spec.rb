describe KnapsackPro::Runners::RSpecRunner do
  subject { described_class.new(KnapsackPro::Adapters::RSpecAdapter) }

  it { should be_kind_of KnapsackPro::Runners::BaseRunner }

  describe '.run' do
    let(:args) { '--profile --color' }

    after { described_class.run(args) }

    before do
      stub_const("ENV", { 'KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC' => 'rspec-token' })

      stringify_test_file_paths = 'spec/a_spec.rb spec/b_spec.rb'
      runner = instance_double(described_class,
                               test_dir: 'spec',
                               stringify_test_file_paths: stringify_test_file_paths)
      expect(described_class).to receive(:new)
      .with(KnapsackPro::Adapters::RSpecAdapter).and_return(runner)

      expect(Kernel).to receive(:system)
      .with('KNAPSACK_PRO_RECORDING_ENABLED=true KNAPSACK_PRO_TEST_SUITE_TOKEN=rspec-token bundle exec rspec --profile --color --default-path spec -- spec/a_spec.rb spec/b_spec.rb')
    end

    context 'when command exit with success code' do
      let(:exitstatus) { 0 }

      before do
        expect($?).to receive(:exitstatus).and_return(exitstatus)
      end

      it do
        expect(Kernel).not_to receive(:exit)
      end
    end

    context 'when command exit without success code' do
      let(:exitstatus) { 1 }

      before do
        expect($?).to receive(:exitstatus).twice.and_return(exitstatus)
      end

      it do
        expect(Kernel).to receive(:exit).with(exitstatus)
      end
    end
  end
end
