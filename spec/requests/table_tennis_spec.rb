require 'rails_helper'

RSpec.describe 'Table Tennis API', type: :request do
    describe '#ping' do
        context 'when unauthenticated' do
            it 'returns unauthenticated pong' do
                get '/ping'
                expect(parsed_body['response']).to eq 'Error - Unauthorized'
            end
        end

        context 'when authenticated' do
            let(:current_user) { FactoryGirl.create :user }
            let(:auth_headers) {
                token = Knock::AuthToken.new(payload: { sub: current_user.id} ).token
                {
                    'Authorization': "Bearer #{token}"
                }
            }

            before { get '/ping', headers: auth_headers }    
                
            it 'works' do
                expect(response).to be_success
            end

            it 'returns authenticated pong' do
               
                expect(parsed_body['response']).to eq 'Authorized pong'
            end
        end
    end
end
