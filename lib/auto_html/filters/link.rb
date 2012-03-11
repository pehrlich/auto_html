require 'rails_autolink'

AutoHtml.add_filter(:link).with({}) do |text, options|
  include ActionView::Helpers::TextHelper
  auto_link(text, :all, options)
end
