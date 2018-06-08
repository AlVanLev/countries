class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy]

  # GET /states
  # GET /states.json
  def index
    @states = State.all.where(active: true)
    @removed_states = State.all.where(active: false)
    @country = Country.all.where(active:true)
  end

  # GET /states/1
  # GET /states/1.json
  def show

  end

  # GET /states/new
  def new
    @state = State.new
    @state.municipalities.build
  end

  # GET /states/1/edit
  def edit
    @state.municipalities.build
  end

  # POST /states
  # POST /states.json
  def create
    @state = State.new(state_params)

    respond_to do |format|
      if @state.save
        format.html { redirect_to @state, notice: 'State was successfully created.' }
        format.json { render :show, status: :created, location: @state }
      else
        format.html { render :new }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /states/1
  # PATCH/PUT /states/1.json
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: 'State was successfully updated.' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.json
  def destroy
    if @state.active
      @state.update(active: false)
    else
      @state.update(active: true)
    end
    respond_to do |format|
      format.html { redirect_to states_url, notice: 'Action completed' }
      format.json { head :no_content }
    end
  end

  def new_state
    @state=State.new
    @state.name=params[:name]
    @state.country_id=params[:country]
    @state.save
    respond_to do |format|
      format.json {render json:@state, :include => {:country => {:only => :name}}}
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      params.require(:state).permit(:name, :country_id, municipalities_attributes: [:id, :name, :_destroy])
    end

end
