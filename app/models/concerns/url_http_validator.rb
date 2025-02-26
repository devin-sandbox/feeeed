module UrlHttpValidator
  extend ActiveSupport::Concern

  included do
    class_attribute :url_http_validatable_columns
  end

  class_methods do
    def validates_url_http_format_of(*columns)
      self.url_http_validatable_columns = columns
      columns.each do |column|
        validates column,
          format: { with: URI.regexp(%w[http https]), message: "is not a valid URL" },
          length: { maximum: 2083 },
          allow_nil: true
      end
    end
  end
end
