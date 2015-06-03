require "spec_helper"

require "sinatra/resource_json_api/query_params_to_sql"

describe Sinatra::ResourceJsonApi::QueryParamsToSql do

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
end

