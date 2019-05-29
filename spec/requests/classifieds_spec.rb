require 'rails_helper'

RSpec.describe "Classifieds", type: :request do
  describe "GET /classifieds:/id" do

    let(:classified) { FactoryGirl.create :classified }
    
    before { get "/classifieds/#{classified.id}" }

    it 'works' do
      expect(response).to be_success
    end
    
    it 'is correctly serialized' do
      expect(parsed_body['id']).to eq classified.id
      expect(parsed_body['title']).to eq classified.title
      expect(parsed_body['price']).to eq classified.price
      expect(parsed_body['description']).to eq classified.description
    end
    
  end
end
