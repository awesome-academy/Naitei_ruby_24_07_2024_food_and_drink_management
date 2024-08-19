module ApplicationHelper
  include Pagy::Frontend
  def full_title page_title
    base_title = t "helper.title_name"
    page_title.blank? ? base_title : "#{page_title}|#{base_title}"
  end

  def status_tag status
    case status
    when 0
      content_tag(:span, "Failed", class: "status failed")
    when 1
      content_tag(:span, "Succeeded", class: "status succeeded")
    when 2
      content_tag(:span, "Confirming", class: "status confirming")
    else
      content_tag(:span, "Unknown", class: "status unknown")
    end
  end

  def convert_currency amount, from_currency = :vnd
    case I18n.locale
    when :en
      if from_currency == :vnd
        usd_amount = amount / 23_000.0
        number_to_currency(usd_amount, unit: "$")
      else
        number_to_currency(amount, unit: "$")
      end
    when :vi
      if from_currency == :usd
        vnd_amount = amount * 23_000.0
        number_to_currency(vnd_amount, unit: "₫", precision: 0)
      else
        number_to_currency(amount, unit: "₫", precision: 0)
      end
    else
      number_to_currency(amount, unit: "₫", precision: 0)
    end
  end
end
