require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    describe 'GET /users/:id' do
        before { get "/users/#{current_user.id}", headers: authentication_header }
      
        it { expect(response).to be_success }

    end
end