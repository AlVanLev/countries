class State < ApplicationRecord
  before_save {self.name = name.upcase}
  belongs_to :country
  has_many :municipalities, dependent: :destroy
  VALID_NAME_REGEX = /\A[\D]*\z/
  accepts_nested_attributes_for :municipalities, reject_if: :reject_municipalities, allow_destroy: true
  validates :name, presence: true, length: {maximum: 25}, uniqueness: {scope: :country}, format:{with: VALID_NAME_REGEX}
  def to_s
    name
  end
  def reject_municipalities(attributes)
    attributes['name'].blank?
  end
end
