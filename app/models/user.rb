class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }

  has_secure_password
  has_secure_token :api_key

  has_many :viewing_party_users, dependent: :destroy
  has_many :hosted_viewing_parties, class_name: 'ViewingParty', foreign_key: :host_id
  has_many :invited_viewing_parties, through: :viewing_party_users, source: :viewing_party
end