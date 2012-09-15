class Order
  include Mongoid::Document
  include Mongoid::Organizational

  field :total, type: BigDecimal
end
