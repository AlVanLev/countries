class State < ApplicationRecord
  belongs_to :country
  has_many :municipalities, dependent: :destroy
  accepts_nested_attributes_for :municipalities, reject_if: :reject_municipalities, allow_destroy: true
  validates :name, presence: true, length: {maximum: 25}
  def to_s
    name
  end
  def reject_municipalities(attributes)
    attributes['name'].blank?
  end
end
