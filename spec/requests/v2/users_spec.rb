require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    describe 'GET /v2/users/:id' do
        before { get "/v2/users/#{current_user.id}", headers: authentication_header }
      
        it { expect(response).to be_success }

        it 'is correctly serialized' do
            expect(parsed_body).to match({
                id: current_user.id,
                username: current_user.username,
                firstname: current_user.firstname,
                lastname: current_user.lastname
            }.stringify_keys)
        end

    end
end