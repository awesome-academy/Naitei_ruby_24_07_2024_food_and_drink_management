class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pagy::Backend

  layout :set_layout

  protected

  def configure_permitted_parameters
    added_attrs = %i(username email password password_confirmation
      remember_me)
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  rescue_from CanCan::AccessDenied do |_exception|
    if current_user
      redirect_to root_path, alert: t("cannot_access")
    else
      redirect_to user_session_path, alert: t("please_login")
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def authenticate_admin!
    return if current_user.admin?

    redirect_to root_path, alert: t("not_admin")
  end

  def set_layout
    current_user&.admin? ? "admin_layouts" : "application"
  end

  def process_fail_order_items
    ActiveRecord::Base.transaction do
      @order.order_items.each do |order_item|
        product = order_item.product
        product.quantity_in_stock += order_item.quantity
        product.save!
      end
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to @order, alert: t("orders.cannot_update_reason")
  end

  def set_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t "orders.not_found"
    redirect_to root_path
  end

  def update_reason
    ActiveRecord::Base.transaction do
      reason = params.dig(:order, :reason)
      @order.update!(reason:) if reason.present?
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to @order, alert: t("orders.cannot_update_reason")
  end
end
