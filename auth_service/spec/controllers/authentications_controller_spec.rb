require "rails_helper"

RSpec.describe AuthenticationsController, type: :controller do
    describe "POST #register" do
        let(:valid_parameters) { attributes_for(:user, password_confirmation: 'password') }
        let(:invalid_parameters) { attributes_for(:user, password: "password", password_confirmation: 'wrong password') }

        context "with valid parameters" do
            before { post :register, params: valid_parameters}

            it "creates a new user" do
                expect(User.count).to eq(1)
                expect(response).to have_http_status(:created)
                expect(json_response["message"]).to eq("User created successfully")
                expect(response.content_type).to include("application/json")
                expect(response.content_type).to include("charset=utf-8")
            end
        end

        context "with invalid parameters" do
            before { post :register, params: invalid_parameters}

            it "should not create a user" do
                expect(response).to have_http_status(:unprocessable_entity)
                expect(json_response["error"]).to include("Password confirmation doesn't match Password")
                expect(User.count).to eq(0)                
            end
        end
    end

    describe "POST #login" do   
        let(:user) { create(:user, email: "existing@example.com") }
        let(:valid_parameters) { attributes_for(:user, email: user.email) }
        let(:invalid_parameters) { attributes_for(:user, email: "wrong email") }

        context "with valid parameters" do
            before { post :login, params: valid_parameters}

            it "should log the user in" do
                expect(response).to have_http_status(:ok)
                expect(json_response["message"]).to eq("Logged in sucessfully")
            end
        end

        context "with invalid parameters" do
            before { post :login, params: invalid_parameters}

            it "should not log the user in" do
                expect(response).to have_http_status(:unauthorized)
                expect(json_response["error"]).to include("Invalid email")
            end
        end
    end
end