require 'rails_helper'
require 'pp'

RSpec.describe "Classifieds", type: :request do
  let(:classified) { FactoryGirl.create :classified, user_id: current_user.id }

  describe "GET /v2/classifieds" do
    let(:page) { 3 } 
    let(:per_page) { 5 }

    context "when everything is going well" do

      before { 
        FactoryGirl.create_list :classified, 5, category: "vehicules"  
        FactoryGirl.create_list :classified, 15, category: "accessories"
      }

        it 'works' do
          get '/v2/classifieds', params: { page: page, per_page: per_page, order: 'asc'}
          expect(response).to have_http_status :partial_content
        end

        it 'returns paginated results when order is asc' do
          get '/v2/classifieds', params: { page: page, per_page: per_page, order: 'asc'}
          expect(parsed_body.map { |c| c['id'] }).to eq Classified.order(created_at: :asc).limit(per_page).offset((page - 1) * per_page).pluck(:id)
        end

        it 'returns paginated results when order is desc' do
          get '/v2/classifieds', params: { page: page, per_page: per_page, order: 'desc'}
          expect(parsed_body.map { |c| c['id'] }).to eq Classified.order(created_at: :desc).limit(per_page).offset((page - 1) * per_page).pluck(:id)
        end

        it 'returns categorized results when category parameter is given' do
          get '/v2/classifieds', params: {page: page, per_page: per_page, order: 'asc', category: 'accessories'}
          parsed_body.each { |classified| expect(classified['category']).to eq 'accessories'}
        end

        it 'returns the correct results when searching' do
          classified_1 = FactoryGirl.create :classified, title: 'Gold jewels'
          classified_2 = FactoryGirl.create :classified, title: 'Off road car'
          classified_3 = FactoryGirl.create :classified, title: 'Great car, almostnew'

          get "/v2/classifieds", params: {page: 1, per_page: 5, order: 'asc', q: 'car'}
          expect(parsed_body.map { |classified| classified['id']}).to eq [classified_2.id, classified_3.id]

        end
1    end

    it 'returns a bad request when page parameter is missing' do
      get '/v2/classifieds', params: {per_page: per_page, order: 'asc'}
      expect(response).to have_http_status :bad_request      
      expect(parsed_body['error']).to eq 'missing parameter page'
    end

    it 'returns a bad request when per_page parameter is missing' do
      get '/v2/classifieds', params: {page: page, order: 'asc'}
      expect(response).to have_http_status :bad_request
      expect(parsed_body['error']).to eq 'missing parameter per_page'
    end

    it 'returns a bad request when order parameter is missing' do
      get '/v2/classifieds', params: {page: page, per_page: per_page}
      expect(response).to have_http_status :bad_request
      expect(parsed_body['error']).to eq 'missing parameter order'
    end

    it 'returns a bad request when order parameter is invalid' do
      get '/v2/classifieds', params: {page: page, per_page: per_page, order: 'trululu'}
      expect(response).to have_http_status :bad_request
      expect(parsed_body['error']).to eq 'Order parameter is invalid must be asc or desc'
    end
  
  end
  

  describe "GET /v2/classifieds:/id" do   

    context 'when everything goes well' do
      before { get "/v2/classifieds/#{classified.id}" }

      it 'works' do
        expect(response).to be_success
      end
      
      it 'is correctly serialized' do

        # pp parsed_body

        expect(parsed_body).to match({
          id: classified.id,
          title: classified.title,
          price: classified.price,
          description: classified.description,
          category: classified.category,
          user: {
            id: classified.user.id,
            fullname: classified.user.fullname
          }.stringify_keys
        }.stringify_keys)


        expect(parsed_body['id']).to eq classified.id
        expect(parsed_body['title']).to eq classified.title
        expect(parsed_body['price']).to eq classified.price
        expect(parsed_body['description']).to eq classified.description
      end
    end

    it 'returns not found when the resource can not be found' do
      get '/v2/classifieds/toto'
      expect(response).to have_http_status :not_found
    end
    
  end

  describe 'POST /v2/classifieds' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        post '/v2/classifieds'
        expect(response).to have_http_status :unauthorized

      end
    end

    context 'when authenticated' do

      let(:params) {
        { classified: { title: 'title', price: 62, description: 'description'} }
      }

      it 'works' do
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :created
      end

      it 'creates a new classiffied' do
        expect {
          post '/v2/classifieds', params: params, headers: authentication_header
        }.to change {
          current_user.classifieds.count
        }.by 1
      end

      it 'has correct fields values for the created classifed' do
        post '/v2/classifieds', params: params, headers: authentication_header
        created_classified = current_user.classifieds.last
        expect(created_classified.title).to eq 'title'
        expect(created_classified.price).to eq 62
        expect(created_classified.description).to eq 'description'
      end

      it 'returns a bad request when a parameter is missing' do
        params[:classified].delete(:price)
        post '/v2/classifieds', params: params, headers: authentication_header
        expect(response).to have_http_status :bad_request        
      end

    end
    
  end 


  describe 'PATCH /v2/classified:id' do
    
    let(:params) {
      { classified: { title: 'A better title', price: 42} }
    }

    context 'when unauthenticated' do
      it 'returns unauthorized' do
        patch "/v2/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do
        before { patch  "/v2/classifieds/#{classified.id}", params: params, headers: authentication_header }
        it { expect(response).to have_http_status :forbidden }
    end
  end


  describe 'DELETE /v2/classified:id' do
    context 'when unauthenticated' do
      it 'returns unauthorized' do
        delete "/v2/classifieds/#{classified.id}"
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when authenticated' do

      context 'when everything goes well' do
        before { delete "/v2/classifieds/#{classified.id}", headers: authentication_header }
        it { expect(response).to have_http_status :no_content }

        it 'deletes the given classified' do
          expect(Classified.find_by(id: classified.id)).to eq nil
        end
      end

      it 'returns a not found when resource can not be found' do
        delete "/v2/classifieds/toto", headers: authentication_header
        expect(response).to have_http_status :not_found
      end

      it 'returns a forbidden when the requester is not the owner of the resource' do
        another_classified = FactoryGirl.create :classified
        delete "/v2/classifieds/#{another_classified.id}", headers: authentication_header
        expect(response).to have_http_status :forbidden
      end

    end

  end

  
end
