class ViewingParty < ApplicationRecord
  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

  belongs_to :host, class_name: 'User', foreign_key: :host_id
  has_many :viewing_party_users, dependent: :destroy
  has_many :invitees, through: :viewing_party_users, source: :user
end