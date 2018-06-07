class Municipality < ApplicationRecord
  belongs_to :state
  validates :name, presence: true, length: {maximum: 25}
  def to_s
    name
  end
end
