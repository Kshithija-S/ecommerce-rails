require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do

    it "should validate email presence" do
      user = build(:user, email: "")
      expect(user).to be_invalid
    end

    it "should validate email" do
      user = build(:user, email: "test@.com")
      expect(user).to be_invalid
    end

    it "should validate email to be unique" do
      create(:user, email: "existing@example.com")
      user = build(:user, email: "existing@example.com") 
      expect(user).to be_invalid
    end
    
    it "should validate password presence" do
      user = build(:user, password: "")
      expect(user).to be_invalid
    end
    
    it "should validate password length if too short" do
      user = build(:user, password: "qwerty")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include "Password is too short (minimum is 8 characters)"
    end
    
    it "should validate password length if too long" do
      user = build(:user, password: "test long password with more than 15 chars")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include "Password is too long (maximum is 15 characters)"
    end

    it "should validate if password does not match password confirmation" do
      user = build(:user, password_confirmation: "wrong password")
      expect(user).to be_invalid
      expect(user.errors.full_messages).to include "Password confirmation doesn't match Password"
    end

    it "should encode token for user" do
      user = build(:user)
      payload = {user_id: user.id}
      token = User.encode_token(payload)
      expect(token).to be_present
    end

    it "should decode token for user" do
      user = create(:user)
      payload = {user_id: user.id}
      token = User.encode_token(payload)

      decoded_user = User.decode_token(token)
      expect(decoded_user["user_id"]).to eq(user.id)
    end
    
    # it "should decode invalid token for user" do
    #   user = create(:user)
    #   payload = {user_id: user.id}
    #   token = User.encode_token(payload)

    #   decoded_user = User.decode_token(token[0..5])
    #   expect(decoded_user).to be_invalid
    # end
  end
end
