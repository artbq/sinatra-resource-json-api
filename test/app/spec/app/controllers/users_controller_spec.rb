require 'spec_helper'

RSpec.describe "/users" do

  describe "index" do

    let!(:grandpa) { create(:user, name: "Bob", age: 71) }
    let!(:grandma) { create(:user, name: "Mary", age: 70) }
    let!(:walter) { create(:user, name: "Walter", age: 50) }
    let!(:walter_jr) { create(:user, name: "Walter", age: 16) }
    let!(:skyler) { create(:user, name: "Skyler", age: 40) }

    before(:each) do
      get "/users", params
    end

    context "without params" do
      let(:params) { {} }

      specify { expect(last_response.status).to eq 200 }
      specify { expect(json["entries"].count).to eq 5 }

      specify "entry's attributes" do
        user = json["entries"].first
        expect(user["id"]).to be
        expect(user["age"]).to be
        expect(user["name"]).to be
        expect(user["created_at"]).to be
        expect(user["updated_at"]).to be
      end

      specify { expect(json["pagination"]["total_entries"]).to eq 5 }
      specify { expect(json["pagination"]["total_pages"]).to eq 1 }
    end

    context "with query params" do

      context "=" do
        let(:params) { {query: {name: "Walter"}} }

        specify { expect(entry_ids).to include walter.id, walter_jr.id }
        specify { expect(entry_ids).to_not include grandpa.id, grandma.id, skyler.id }
      end

      context "= and =" do
        let(:params) { {query: {name: "Walter", age: 16}} }

        specify { expect(entry_ids).to include walter_jr.id }
        specify { expect(entry_ids).to_not include walter.id, grandpa.id, grandma.id, skyler.id }
      end

      context "= or =" do
        let(:params) { {query: {or: {"0" => {name: "Walter"}, "1" => {age: 70}}}} }

        specify { expect(entry_ids).to include walter.id, walter_jr.id, grandma.id }
        specify { expect(entry_ids).to_not include grandpa.id, skyler.id }
      end
    end
  end
end

