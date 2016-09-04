module KnapsackPro
  module Runners
    class ZeusRSpecRunner < BaseRunner
      def self.run(args)
        ENV['KNAPSACK_PRO_TEST_SUITE_TOKEN'] = KnapsackPro::Config::Env.test_suite_token_rspec

        runner = new(KnapsackPro::Adapters::RSpecAdapter)

        cmd = %Q[KNAPSACK_PRO_RECORDING_ENABLED=true KNAPSACK_PRO_TEST_SUITE_TOKEN=#{ENV['KNAPSACK_PRO_TEST_SUITE_TOKEN']} bundle exec zeus rspec #{args} --default-path #{runner.test_dir} -- #{runner.stringify_test_file_paths}]

        Kernel.system(cmd)
        Kernel.exit($?.exitstatus) unless $?.exitstatus.zero?
      end
    end
  end
end
