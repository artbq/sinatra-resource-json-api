require "spec_helper"

require "sinatra/resource_json_api/util"

describe Sinatra::ResourceJsonApi::Util do

  describe ".array_hash_to_array" do

    subject { described_class.array_hash_to_array(hash) }

    let(:hash) do
      {
        "0" => :a,
        "1" => {b: :c, d: :e},
        "2" => [:f, :g],
        "3" => {"0" => :h, "1" => :i},
        "4" => :j
      }
    end

    it { should eq [:a, {b: :c, d: :e}, [:f, :g], [:h, :i], :j] }
  end
end

