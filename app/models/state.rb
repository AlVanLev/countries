class State < ApplicationRecord
  belongs_to :country
  has_many :municipalities, dependent: :destroy
  validates :name, presence: true, length: {maximum: 25}
  validates :country_id, presence: true
end
