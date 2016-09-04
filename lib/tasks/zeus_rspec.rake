require 'knapsack_pro'

namespace :knapsack_pro do
  task :zeus_rspec, [:rspec_args] do |_, args|
    KnapsackPro::Runners::ZeusRSpecRunner.run(args[:rspec_args])
  end
end
