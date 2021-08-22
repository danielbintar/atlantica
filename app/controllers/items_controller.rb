class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy add_child destroy_child chemist]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /items/1/addchild
  def add_child
    raise 'count should be positive' if child_params[:count].to_i <= 0

    @item.childs[child_params[:id]] = child_params[:count]
    @item.save!
    redirect_to @item, notice: "Child was successfully created."
  end

  # DELETE /items/1/addchild/2
  def destroy_child
    child = Item.find(params[:child_id])
    @item.childs.except!(child.id.to_s)
    @item.save!
    redirect_to @item, notice: "Child was successfully destroyed."
  end

  # GET /items/1/chemist?count=
  def chemist
    raise 'count should be positive' if params[:count].to_i <= 0

    @forms = @item.cheapest_form(params[:count].to_i)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :price, :batch)
    end

    def child_params
      params.require(:item).permit(:id, :count)
    end
end
