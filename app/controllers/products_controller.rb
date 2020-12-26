class ProductsController < ::ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = ::Product.all

    render json: ProductIndexSerializer.new(@products).serializable_hash.to_json
  end

  def show
    render json: ProductIndexSerializer.new(@product).serializable_hash.to_json
  end

  def create
    @product = ::Product.new(product_create_params)

    if @product.save
      render_json_message({:success => t('.success')}, 201, {id: @product.id})
      render json: Panko::ArraySerializer.new(users, each_serializer: UserSerializer).to_json
    else
      render_json_message({:errors => @product.errors.messages}, 422)
    end
  end

  def update
    if @product.update(product_update_params)
      render_json_message({success: t('.success')}, 200)
    else
      render_json_message({errors: @product.errors.messages}, 422)
    end
  end

  def destroy
    if @product.destroy
      render_json_message({:success => t('.success')}, 200)
    else
      render_json_message({:errors => @product.errors.messages}, 422)
    end
  end

  def recover
    @product = ::Product.with_deleted.find(params[:id])

    if @product.restore
      render_json_message({:success => t('.success')}, 200)
    else
      render_json_message({:errors => @product.errors.messages}, 422)
    end
  end

  private

  def product_params
    params.require(:product).permit(
        :code,
        :name,
        :description,
        :cod_emp,
        :food_restrictions => []
    )
  end

  # def product_create_params
  #   product_params.merge(created_by_id: @current_user.id, cod_emp: @current_user&.cod_emp)
  # end
  #
  # def product_update_params
  #   product_params.merge(updated_by_id: @current_user.id, cod_emp: @current_user&.cod_emp)
  # end

  def set_product
    @product = ::Product.all.find(params[:id])
  end
end
