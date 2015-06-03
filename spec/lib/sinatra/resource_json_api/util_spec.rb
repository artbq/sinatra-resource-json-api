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

    context "case 1" do
      let(:hash) { {"query" => {"or" => {"0" => {"name" => "Walter"}, "1" => {"age" => 70}}}} }
      it { should eq Hash["query", {"or" => [{"name" => "Walter"}, {"age" => 70}]}] }
    end
  end
end

