require 'rails_helper'

RSpec.describe "Classifieds", type: :request do
  describe "GET /classifieds:/id" do

    let(:classified) { FactoryGirl.create :classified }
    
    it 'works' do
      get "/classifieds/#{classified.id}"
      expect(response).to be_success
    end
    
    it 'is correctly serialized' do
      get "/classifieds/#{classified.id}"
      expect(JSON.parse(response.body)['id']).to eq classified.id
      expect(JSON.parse(response.body)['title']).to eq classified.title
      expect(JSON.parse(response.body)['price']).to eq classified.price
      expect(JSON.parse(response.body)['description']).to eq classified.description
    end
    
  end
end
