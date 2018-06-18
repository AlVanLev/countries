class StatesController < ApplicationController
  before_action :set_state, only: [:show, :edit, :update, :destroy, :state_active]
  before_action :set_states, only: [:index, :download]


  # GET /states
  # GET /states.json
  def index
    @removed_states = State.all.where(active: false)
    @countries = Country.all.where(active:true)
  end

  # GET /states/1
  # GET /states/1.json
  def show

  end

  # GET /states/new
  def new
    @state = State.new
    @countries = Country.all.where(active: true)
    @state.municipalities.build
  end

  # GET /states/1/edit
  def edit
    @state.municipalities.build
    @countries = Country.all.where(active: true)
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
    @state.destroy
    respond_to do |format|
      format.html { redirect_to states_url, notice: 'State removed' }
      format.json { head :no_content }
    end
  end

  def state_active
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
    if @state.save
      respond_to do |format|
        format.json {render json:@state, :include => {:country => {:only => :name}}}
        format.js
      end
    end
  end

  def download
  #Crea un excel en la carpeta public
  workbook  = WriteXLSX.new('public/states.xlsx')
  worksheet = workbook.add_worksheet


  header_format = workbook.add_format(font: "Arial", size: 12, align: "center")
  header_format.set_text_wrap()
  header_format.set_bold
  header_format.set_bg_color("#DFF0D8")
  header_format.set_color("#008857")
  data_format = workbook.add_format(font: "Arial", size: 12, align: "right", italic: true, color: "#5588ff", text_wrap: true)


  worksheet.set_column('A:A', 45)
  worksheet.set_column('B:B', 45)
  worksheet.set_column('C:C', 45)

  #Encabezados
  #(fila , columna, encabezado)
  worksheet.write(0, 0, ' State ',header_format)
  worksheet.write(0, 1, ' Country ',header_format)


  #Indices
  fila = 1
  columna = 0

  #Escribe los datos de la bdd
  @states.each do |state|
    worksheet.write(fila, columna       , state.name,data_format )
    worksheet.write(fila, columna+1       , Country.where(id: state.country_id).pluck(:name).to_sentence,data_format )
    #Avanza una fila
    fila += 1
  end

  #Cierra el archivo
  workbook.close()

  #descarga el archivo
  File.open("public/states.xlsx", "r") do |f|
   send_data f.read, :filename => "states.xlsx", type: "application/xlsx"
  end

  #Elimina el archivo de la carpet public
  File.delete("public/states.xlsx")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    def set_states
      @states = State.all.where(active: true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def state_params
      params.require(:state).permit(:name, :country_id, municipalities_attributes: [:id, :name, :_destroy])
    end

end
