require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    describe "Authorization" do
        let(:invalid_token) { "smwkidowkdkedoopwkfowkfwdw32e2e3ed3dd" }
        let(:invalid_headers) { { "Authorization" => "Bearer #{invalid_token}" }}

        it "should throw error when token not passed" do
            post :create
            expect(response).to have_http_status(:forbidden)
            expect(json_response["error"]).to include("You must provide a token")
        end

        # it "should throw error when invalid token is passed" do
        #     post :create, params: {}, headers: invalid_headers
        #     expect(response).to have_http_status(:unauthorized)
        #     expect(json_response["error"]).to include("Invalid token")
        # end
    end
end
