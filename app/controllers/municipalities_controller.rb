class MunicipalitiesController < ApplicationController
  before_action :set_municipality, only: [:show, :edit, :update, :destroy, :municipality_active]
  before_action :set_municipalities, only: [:index, :download]
  before_action :set_states, only:[:new,:edit,:index]

  # GET /municipalities
  # GET /municipalities.json
  def index
    @removed_municipalities = Municipality.all.where(active: false)
  end

  # GET /municipalities/1
  # GET /municipalities/1.json
  def show
  end

  # GET /municipalities/new
  def new
    @municipality = Municipality.new
  end

  # GET /municipalities/1/edit
  def edit
  end

  # POST /municipalities
  # POST /municipalities.json
  def create
    @municipality = Municipality.new(municipality_params)

    respond_to do |format|
      if @municipality.save
        format.html { redirect_to @municipality, notice: 'Municipality was successfully created.' }
        format.json { render :show, status: :created, location: @municipality }
      else
        format.html { render :new }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /municipalities/1
  # PATCH/PUT /municipalities/1.json
  def update
    respond_to do |format|
      if @municipality.update(municipality_params)
        format.html { redirect_to @municipality, notice: 'Municipality was successfully updated.' }
        format.json { render :show, status: :ok, location: @municipality }
      else
        format.html { render :edit }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipalities/1
  # DELETE /municipalities/1.json
  def destroy
    @municipality.destroy
    respond_to do |format|
      format.html { redirect_to municipalities_url, notice: 'Municipality removed' }
      format.json { head :no_content }
    end
  end

  def municipality_active
    if @municipality.active
      @municipality.update(active: false)
    else
      @municipality.update(active: true)
    end
    respond_to do |format|
      format.html { redirect_to municipalities_url, notice: 'Action completed' }
      format.json { head :no_content }
    end
  end

  def new_municipality
    @municipality=Municipality.new
    @municipality.name=params[:name]
    @municipality.state_id=params[:state]
    if @municipality.save
      respond_to do |format|
        format.json {render json:@municipality,:include => {:state =>{:only => :name}}}
        format.js
      end
    end
  end

  def download
  #Crea un excel en la carpeta public
  workbook  = WriteXLSX.new('public/Municipalities.xlsx')
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
  worksheet.write(0, 0, ' Municipality ',header_format)
  worksheet.write(0, 1, ' State ',header_format)

  #Indices
  fila = 1
  columna = 0

  #Escribe los datos de la bdd
  @municipalities.each do |municipality|
    worksheet.write(fila, columna       , municipality.name,data_format  )
    worksheet.write(fila, columna+1       , State.where(id:municipality.state_id).pluck(:name).to_sentence,data_format  )

    #Avanza una fila
    fila += 1
  end

  #Cierra el archivo
  workbook.close()

  #descarga el archivo
  File.open("public/Municipalities.xlsx", "r") do |f|
   send_data f.read, :filename => "Municipalities.xlsx", type: "application/xlsx"
  end

  #Elimina el archivo de la carpet public
  File.delete("public/Municipalities.xlsx")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_municipality
      @municipality = Municipality.find(params[:id])
    end

    def set_municipalities
      @municipalities = Municipality.all.where(active: true)
    end

    def set_states
      @states = State.all.where(active:true,country_id:Country.all.where(active:true).pluck(:id))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def municipality_params
      params.require(:municipality).permit(:name, :state_id)
    end
end
