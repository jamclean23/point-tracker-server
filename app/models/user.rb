class User < ApplicationRecord
    has_secure_password

    before_validation :set_uuid
  
    validates :username, presence: true, length: { in: 8..20 }, uniqueness: true
    validates :password_digest, presence: true
    validates :first_name, presence: true, length: { in: 1..30 }
    validates :last_name, presence: true, length: { in: 1..20 }
    validates :email, presence: true, length: { maximum: 345 }, uniqueness: true
    validates :phone, length: { in: 10..20 }, allow_blank: true
    validates :note, length: { maximum: 2000 }, allow_blank: true
    validates :admin, inclusion: { in: [true, false] }
    validates :approved, inclusion: { in: [true, false] }
  
    private
  
    def set_uuid
      self.id = SecureRandom.uuid if self.id.nil?
    end
end
