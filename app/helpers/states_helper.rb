module StatesHelper
  def country(state)
    Country.active.where(id:state.country_id).pluck(:name).to_sentence
  end
end
