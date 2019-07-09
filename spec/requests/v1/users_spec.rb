require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    describe 'GET /v1/users/:id' do
        before { get "/v1/users/#{current_user.id}", headers: authentication_header }
      
        it { expect(response).to be_success }

        it 'is correctly serialized' do
            expect(parsed_body).to match({
                id: current_user.id,
                username: current_user.username,
                fullname: current_user.fullname,
            }.stringify_keys)
        end

    end
end