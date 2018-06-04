class Country < ApplicationRecord
  has_many :states, dependent: :destroy
  accepts_nested_attributes_for :states, reject_if: proc { |attr| attr['name'].blank?}, allow_destroy: true
  validates :name, presence: true, length: {maximum: 25}

end
