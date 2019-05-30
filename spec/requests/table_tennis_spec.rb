require 'rails_helper'

RSpec.describe 'Table Tennis API', type: :request do
    describe '#ping' do
        context 'when unauthenticated' do

            before { get '/ping' }    

            it 'works' do
                expect(response).to be_success
            end

            it 'returns unauthenticated pong' do
                expect(parsed_body['response']).to eq 'Error - Unauthorized'
            end
        end

        context 'when authenticated' do
            before { get '/ping', headers: authentication_header }    
                
            it 'works' do
                expect(response).to be_success
            end

            it 'returns authenticated pong' do
               
                expect(parsed_body['response']).to eq 'Authorized pong'
            end
        end
    end
end
