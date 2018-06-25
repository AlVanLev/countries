class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy, :country_active]
  before_action :set_countries, only: [:index, :download]

  # GET /countries
  # GET /countries.json
  def index
    @removed_Countries = Country.all.where(active: false)
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
  end

  # GET /countries/new
  def new
    @country[i] = Country.new
    @country.states.build
  end

  # GET /countries/1/edit
  def edit
    @country.states.build
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(country_params)
    respond_to do |format|
      if @country.save
        format.html { redirect_to @country, notice: 'Country was successfully created.' }
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :new }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to @country, notice: 'Country was successfully updated.' }
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Country removed' }
      format.json { head :no_content }
    end
  end

  def country_active
    if @country.active
      @country.update(active: false)
    else
      @country.update(active: true)
    end
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Action completed' }
      format.json { head :no_content }
    end
  end

  def new_country
    @country=Country.new
    @country.name=params[:name]
    if @country.save
      respond_to do |format|
        format.json { render json: @country }
        format.js
      end
    else
      format.html { render :index }
      format.json { render json: @country.errors, status: :unprocessable_entity }
    end
  end

  def download
    #Crea un excel en la carpeta public
    workbook  = WriteXLSX.new('public/Countries.xlsx')
    worksheet = workbook.add_worksheet

    header_format = workbook.add_format(font: "Arial", size: 12, align: "center")
    header_format.set_text_wrap()
    header_format.set_bold
    header_format.set_bg_color("#DFD0D8")
    header_format.set_color("#008857")
    data_format = workbook.add_format(font: "Arial", size: 12, align: "right", italic: true, color: "#5588ff", text_wrap: true)

    worksheet.set_column('A:A', 45)
    worksheet.set_column('B:B', 45)
    worksheet.set_column('C:C', 45)
    #Encabezados
    #(fila , columna, encabezado)
    worksheet.write(0, 0, ' Country ',header_format)
    #Indices
    fila = 1
    columna = 0
    #Escribe los datos de la bdd
    @countries.each do |country|
      worksheet.write(fila, columna, country.name, data_format)
      #Avanza una fila
      fila += 1
    end
    #Cierra el archivo
    workbook.close()
    #descarga el archivo
    File.open("public/Countries.xlsx", "r") do |f|
     send_data f.read, :filename => "Countries.xlsx", type: "application/xlsx"
    end
    #Elimina el archivo de la carpet public
    File.delete("public/Countries.xlsx")
  end

  def ajax_import
    import_failure=false
    country_hash = params[:countries]
    country_hash.each do |key,value|
      @country=Country.new
      @country.name=value[:name]
      if !@country.save
        import_failure=true
      end
    end
    if import_failure
      format.html { redirect_to countries_url, notice: 'Import successful' }
    else
      format.html { redirect_to countries_url, notice: 'Problems importing' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
    end

    def set_countries
      @countries = Country.all.where(active: true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:name,:active,:countries, states_attributes: [:id, :name, :_destroy])
    end
end
