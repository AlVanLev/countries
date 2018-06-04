class Municipality < ApplicationRecord
  belongs_to :state
  validates :name, presence: true, length: {maximum: 25}
  validates :state_id, presence: true
end
