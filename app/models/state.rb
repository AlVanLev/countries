class State < ApplicationRecord
  before_save {self.name = name.upcase}
  belongs_to :country
  has_many :municipalities, dependent: :destroy
  VALID_NAME_REGEX = /\A[\D]*\z/
  accepts_nested_attributes_for :municipalities, reject_if: :reject_municipalities, allow_destroy: true
  validates :name, presence: true, length: {maximum: 25}, uniqueness: {scope: :country}, format:{with: VALID_NAME_REGEX}

  scope :active,->{where(active:true,country_id: Country.all.active.pluck(:id))}
  scope :inactive,->{where(active:false).or(where(country_id: Country.all.inactive.pluck(:id)))}
  scope :find_id_name,->(name){where(name:name).pluck(:id)}

  def to_s
    name
  end
  def reject_municipalities(attributes)
    attributes['name'].blank?
  end
end
