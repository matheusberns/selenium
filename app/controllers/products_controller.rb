# frozen_string_literal: true

class ProductsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_product
  before_action :set_product, only: %i[show update destroy recover]

  # GET /products
  def index
    @products = Product.all_fields

    @products = apply_filters(@products,
                              :active_boolean,
                              :by_derivation,
                              :by_name)

    # index_render_json(@products, ::ProductSerializer, 'products')
    render template: "products/index"
  end

  # GET /products/1
  def show
    render_json(@product, ::ProductSerializer, 'product')
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render_json(Product.all_fields.find(@product.id), ::ProductSerializer, 'product')
    else
      render json: {errors: @product.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render_json(@product, ::ProductSerializer, 'product')
    else
      render json: {errors: @product.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    if @product.destroy
      render_json(@product, ::ProductSerializer, 'product')
    else
      render json: {errors: @product.errors}, status: :unprocessable_entity
    end
  end

  def recover
    if @product.restore
      render_json(@product, ::ProductSerializer, 'product')
    else
      render json: {errors: @product.errors}, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.all_fields.find(params[:id])
  end

  # def product_create_params
  #   product_params.merge(created_by_id: @current_user.id)
  # end
  #
  # def product_update_params
  #   product_params.merge(updated_by_id: @current_user.id)
  # end

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name,
                                    :code,
                                    :description,
                                    :derivation,
                                    :price)
  end
end
