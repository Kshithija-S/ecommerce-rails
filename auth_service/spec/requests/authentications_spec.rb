require 'rails_helper'

RSpec.shared_examples 'a registration error' do |error_message, extra_params|
  let(:user_count) { 1 }
  it "when #{error_message}" do
    post '/register', params: attributes_for(:user, password_confirmation: "password").merge(extra_params)
    expect(User.count).to be(user_count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response['error']).to include(error_message)
  end
end

RSpec.shared_examples 'a login error' do |error_message, extra_params|
  it "when #{error_message}" do
    post '/login', params: attributes_for(:user, email: "alreadytaken@example.com").merge(extra_params)
    expect(response).to have_http_status(:unauthorized)
    expect(json_response['error']).to include(error_message)
  end
end

RSpec.describe 'Authentications', type: :request do

  before do
   create(:user, email: 'alreadytaken@example.com')
  end

  describe 'POST /register' do
    let(:valid_attributes) { attributes_for(:user, password_confirmation: 'password') }

    context 'with valid parameters' do
      before { post '/register', params: valid_attributes }

      it 'creates a User' do
        expect(User.count).to eq(2)
        expect(User.last.email).to eq(valid_attributes[:email])
      end

      it 'returns a JWT token' do
        expect(response).to have_http_status(:created)
        expect(json_response['token']).not_to be_nil
      end

      it 'returns a success message' do
        expect(json_response['message']).to eq('User created successfully')
      end
    end

    context 'with invalid parameters' do
      it_behaves_like 'a registration error', 'Email has already been taken', email: "alreadytaken@example.com"
      it_behaves_like 'a registration error', "Email can't be blank", email: ''
      it_behaves_like 'a registration error', "Password can't be blank", password: '', password_confirmation: ''
      it_behaves_like 'a registration error', "Password confirmation doesn't match Password", password: "password", password_confirmation: "wrong password"
      it_behaves_like 'a registration error', "Email is invalid", email: 'magesh@.com'
      it_behaves_like 'a registration error', "Email is invalid", email: 'magesh@gmail#.com'
      it_behaves_like 'a registration error', "Password is too short (minimum is 8 characters)", password: 'short', password_confirmation: 'short'
      it_behaves_like 'a registration error', "Password is too long (maximum is 15 characters)", password: 'itstoolongpassword', password_confirmation: 'itstoolongpassword'
    end
  end
  
  describe 'POST /login' do
    let(:valid_attributes) { attributes_for(:user, email: "alreadytaken@example.com") }
    
    context "with valid parameters" do
      before { post "/login", params: valid_attributes }

      it 'returns a JWT token' do
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).not_to be_nil
      end

      it "should login successfully" do
        expect(response).to have_http_status(:ok)
        expect(json_response["message"]).to eq("Logged in sucessfully")
      end
    end

    context "with invalid parameters" do
      it_behaves_like "a login error", "Invalid password", password: "wrong password"
      it_behaves_like "a login error", "Invalid email", email: "newEmail@example.com"
    end
  end
end