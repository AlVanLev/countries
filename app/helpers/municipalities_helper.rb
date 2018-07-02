module MunicipalitiesHelper
  def state(municipality)
    State.active.where(id:municipality.state_id).pluck(:name).to_sentence
  end
end
