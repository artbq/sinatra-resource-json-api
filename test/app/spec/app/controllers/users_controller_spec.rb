require 'spec_helper'

RSpec.describe "/users" do

  describe "index" do

    before do
      create_list(:user, 3)
      get "/users"
    end

    specify { expect(last_response).to be_ok }
    specify { expect(json["entries"].count).to eq 3 }

    specify "entry's attributes" do
      user = json["entries"].first
      expect(user["id"]).to be
      expect(user["age"]).to be
      expect(user["name"]).to be
      expect(user["created_at"]).to be
      expect(user["updated_at"]).to be
    end

    specify { expect(json["pagination"]["total_entries"]).to eq 3 }
    specify { expect(json["pagination"]["total_pages"]).to eq 1 }
  end
end

