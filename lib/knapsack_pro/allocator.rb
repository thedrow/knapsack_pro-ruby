module KnapsackPro
  class Allocator
    def initialize(args)
      @test_files = args.fetch(:test_files)
      @ci_node_total = args.fetch(:ci_node_total)
      @ci_node_index = args.fetch(:ci_node_index)
      @repository_adapter = args.fetch(:repository_adapter)
    end

    def test_file_paths
      encrypted_test_files = KnapsackPro::Crypto::Encryptor.call(test_files)
      action = KnapsackPro::Client::API::V1::BuildDistributions.subset(
        commit_hash: repository_adapter.commit_hash,
        branch: repository_adapter.branch,
        node_total: ci_node_total,
        node_index: ci_node_index,
        test_files: encrypted_test_files,
      )
      connection = KnapsackPro::Client::Connection.new(action)
      response = connection.call
      if connection.success?
        raise ArgumentError.new(response) if connection.errors?
        decrypted_test_files = KnapsackPro::Crypto::Decryptor.call(test_files, response['test_files'])
        KnapsackPro::TestFilePresenter.paths(decrypted_test_files)
      else
        test_flat_distributor = KnapsackPro::TestFlatDistributor.new(test_files, ci_node_total)
        test_files_for_node_index = test_flat_distributor.test_files_for_node(ci_node_index)
        KnapsackPro::TestFilePresenter.paths(test_files_for_node_index)
      end
    end

    private

    attr_reader :test_files,
      :ci_node_total,
      :ci_node_index,
      :repository_adapter
  end
end
