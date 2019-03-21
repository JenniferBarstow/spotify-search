require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Search Spec', type: :request do
  let(:user) { create(:user) }
  let!(:search_result_1) { create(:search_result, user: user, album_name: 'B The memory', release_date: '1998-02-25', album_url: 'test.com/dasdas') }
  let!(:search_result_2) { create(:search_result, user: user, album_name: 'A something', release_date: '2005-02-25', album_url: 'test.com/dasdas') }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  # This will add a valid token for `user` in the `Authorization` header
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, user) }

  context 'user_searches' do
    context 'no filtering' do
      before do  
        get '/user_searches', headers: auth_headers
      end
  
      it 'returns 200' do        
        result = JSON.parse(response.body)["search_results"]
        expect(result.count).to eq 2
        expect(result.first["album_name"]).to eq search_result_1.album_name
        expect(result.first["release_date"]).to eq search_result_1.release_date
        expect(result.last["album_name"]).to eq search_result_2.album_name
        expect(result.last["release_date"]).to eq search_result_2.release_date
        expect(response).to have_http_status(200)
      end
    end

    context 'filter search results by release year' do
      before do  
        get '/user_searches?year=1998', headers: auth_headers
      end
  
      it 'returns 200' do        
        result = JSON.parse(response.body)["search_results"]
        expect(result.count).to eq 1
        expect(result.first["album_name"]).to eq search_result_1.album_name
        expect(result.first["release_date"]).to eq search_result_1.release_date
        expect(response).to have_http_status(200)
      end
    end
    
    context 'filter search results by invalid release year' do
      before do  
        get '/user_searches?year=1998xyz', headers: auth_headers
      end
  
      it 'returns 422 unprocesable entity' do        
        result = JSON.parse(response.body)["error"]        
        expect(result).to eq "Please enter a valid year (1950-2019)"
        expect(response).to have_http_status(422)
      end
    end

    context 'sort search results by album names' do
      before do  
        get '/user_searches?sort=album_name', headers: auth_headers
      end
  
      it 'returns 200' do        
        result = JSON.parse(response.body)["search_results"]
        expect(result.count).to eq 2
        expect(result.first["album_name"]).to eq search_result_2.album_name
        expect(result.first["release_date"]).to eq search_result_2.release_date
        expect(result.last["album_name"]).to eq search_result_1.album_name
        expect(result.last["release_date"]).to eq search_result_1.release_date
        expect(response).to have_http_status(200)
      end
    end

  end  
end
