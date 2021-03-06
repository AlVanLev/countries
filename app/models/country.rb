class Country < ApplicationRecord
  before_save {self.name = name.upcase}
  has_many :states, dependent: :destroy
  accepts_nested_attributes_for :states, reject_if: :reject_states, allow_destroy: true
  VALID_NAME_REGEX = /\A[\D]*\z/
  validates :name, presence: true, length: {maximum: 25}, uniqueness: true, format:{with: VALID_NAME_REGEX}

  scope :active,->{where(active:true)}
  scope :inactive,->{where(active:false)}
  scope :find_id_name,->(name){where(name:name).pluck(:id)}

  def reject_states(attributes)
    attributes['name'].blank?
  end
  def to_s
    name
  end
end
