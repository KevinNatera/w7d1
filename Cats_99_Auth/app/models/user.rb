# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :user_name, :password_digest, :session_token, presence: true
    validates :user_name, :session_token, uniqueness:true
    validates :password, length: {minimum: 6 }, allow_nil: true

    attr_reader :password
    before_validation :ensure_session_token

    def password=(password)
        self.password_digest = BCrypt::Password.new(password)
        @password = password
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        self.sessiontoken = SecureRandom::urlsafe_base64
        self.save! 
        self.session_token
    end

end
