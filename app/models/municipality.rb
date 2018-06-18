class Municipality < ApplicationRecord
  before_save {self.name = name.upcase}
  belongs_to :state
  VALID_NAME_REGEX = /\A[\D]*\z/
  validates :name, presence: true, length: {maximum: 25}, uniqueness: {scope: :state}, format:{with: VALID_NAME_REGEX}
  def to_s
    name
  end
end
