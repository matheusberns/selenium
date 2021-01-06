class ApplicationController < ActionController::Base
  include ::DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session
  before_action :check_auth

  def index_render_json(objects, serializer, nick)
    objects = sortable(objects)

    page_objects = objects.paginate(page: params[:page] || 1, per_page: params[:per_page] || 30)

    render json: { nick => serializer.new(page_objects).serializable_hash[:data].map { |data| data[:attributes] }, meta: { count: objects.size, now: Time.now.to_i } }
  end

  def render_json(object, serializer, nick)
    render json: { success: I18n.t("#{nick}.#{params[:action]}.success"), nick => serializer.new(object).serializable_hash[:data][:attributes] }, status: 200
  end

  def render_json_enum_collection(enum_class, nick)
    @objects = []

    enum_class.to_a.each do |first, second|
      @objects << { id: second, name: first }
    end

    render json: { nick => @objects }, meta: @meta, status: 200
  end

  def render_json_enum(object, nick)
    render json: { nick => { id: object[1], name: object[0] }, meta: @meta }, status: status
  end

  def sortable(array_of_objects)
    params_sort_property = params[:sort_property]
    params_sort_direction = params[:sort_direction]

    if params_sort_property
      sort_properties = params_sort_property.gsub(' ', '').split(',')
      sort_directions = params_sort_direction.gsub(' ', '').split(',') if params_sort_direction

      sort_properties.each_with_index do |sort_property, index|
        if sort_directions
          sort_direction = sort_directions[index]
          sort_directions_first = sort_directions.first

          sort_direction = sort_directions_first if sort_directions.size == 1 && sort_directions_first == 'asc' || sort_directions_first == 'desc'
        end

        order_method = "order_by_#{sort_property.to_s.downcase}".to_sym
        if array_of_objects.respond_to? order_method
          array_of_objects = array_of_objects.send(order_method, sort_direction)
        elsif array_of_objects.first.try(:class).try { column_names.include?(sort_property.to_s) }
          array_of_objects = if sort_direction
                               array_of_objects.order(sort_property.to_sym => sort_direction)
                             else
                               array_of_objects.order(sort_property)
                             end
        end
      end
    end

    array_of_objects
  end

  def apply_filters(objects, *scopes)
    scopes.each do |scope|
      scope_string = scope.to_s
      param_name = scope_string.sub('by_', '')
      params_item = params[param_name]

      # Date range
      if scope_string.include?('_date_range')
        param_name = param_name.sub('_date_range', '')
        scope_name = scope_string.sub('_date_range', '')
        scope = scope_name.to_sym

        first_param = params["start_#{param_name}".to_sym]
        last_param = params["end_#{param_name}".to_sym]

        objects = objects.send(scope, first_param, last_param)
        # Booleans
      elsif scope_string.include?('_boolean')
        param_name = param_name.sub('_boolean', '')
        scope_name = scope_string.sub('_boolean', '')
        params_item = params[param_name]
        scope = scope_name.to_sym

        if params_item.to_s == 'true'
          objects = objects.send(scope, true)
        elsif params_item.to_s == 'false'
          objects = objects.send(scope, false)
        end
      elsif params_item && objects.respond_to?(scope)
        objects = if (params_item.to_s != 'true') && (params_item.to_s != 'false')
                    objects.send(scope, params_item)
                  else
                    objects.send(scope)
                  end
      end
    end

    objects
  end

  private

  def check_auth
    email = request.headers[:uid] || params[:email]

    if json_request?
      if ::Integration.check_auth(authkey: request.headers[:authkey], app_type: request.headers[:appid], email: email)
        true
      else
        render json: { error: t('devise_token_auth.sessions.create.error_permission'), meta: @meta }, status: 401
      end
    else
      true
    end
  end

  def json_request?
    (request.headers['Accept'].present? && request.headers['Accept'].include?('application/json') && !request.headers['Accept'].include?('text/html') && !request.headers['Accept'].include?('application/xhtml+xml')) || params[:format].to_s == 'json' || request.env['action_dispatch.original_path'] =~ %r{^/.json}
  end
end
