require "spec_helper"

require "sinatra/resource_json_api/helpers"

describe Sinatra::ResourceJsonApi::Helpers do

  describe ".query_params_to_sql" do

    subject { described_class.query_params_to_sql(params, options) }

    context "without options" do
      let(:options) { nil }

      describe "=" do
        let(:params) { {name: "Foo"} }
        it { should eq "(name = 'Foo')" }
      end

      describe "= and =" do
        let(:params) { {name: "Foo", age: 666} }
        it { should eq "((name = 'Foo') AND (age = '666'))" }
      end

      describe "= or =" do
        let(:params) { {or: [{name: "Foo"}, {age: 666}]} }
        it { should eq "((name = 'Foo') OR (age = '666'))" }
      end

      describe "((= AND =) or =)" do
        let(:params) { {or: [{name: "Foo", age: 13}, {age: 666}]} }
        it { should eq "(((name = 'Foo') AND (age = '13')) OR (age = '666'))" }
      end

      describe "((= OR =) AND =)" do
        let(:params) { {or: [{name: "Foo"}, {age: 13}], species: "dog"} }
        it { should eq "(((name = 'Foo') OR (age = '13')) AND (species = 'dog'))" }
      end

      describe "<" do
        let(:params) { {"<" => {age: 100}} }
        it { should eq "(age < '100')" }
      end

      describe "<=" do
        let(:params) { {"<=" => {age: 100}} }
        it { should eq "(age <= '100')" }
      end

      describe ">" do
        let(:params) { {">" => {age: 100}} }
        it { should eq "(age > '100')" }
      end

      describe ">=" do
        let(:params) { {">=" => {age: 100}} }
        it { should eq "(age >= '100')" }
      end

      describe "<>" do
        let(:params) { {"<>" => {age: 100}} }
        it { should eq "(age <> '100')" }
      end

      describe "is null" do
        let(:params) { {is_null: "name"} }
        it { should eq "(name IS NULL)" }
      end

      describe "is not null" do
        let(:params) { {is_not_null: "name"} }
        it { should eq "(name IS NOT NULL)" }
      end

      describe "in" do
        let(:params) { {in: {name: ["Foo", "Bar", "Baz"]}} }
        it { should eq "(name IN ('Foo', 'Bar', 'Baz'))" }
      end

      describe "= OR IS NULL" do
        let(:params) { {or: [{name: "Foo"}, {is_null: "name"}] } }
        it { should eq "((name = 'Foo') OR (name IS NULL))" }
      end
    end
  end

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

