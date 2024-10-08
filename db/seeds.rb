ElasticsearchClient = Elasticsearch::Client.new(
  url: 'http://elasticsearch:9200',
  log: true,
  user: 'elastic',
  password: '123456'
)
categories = ["com", "tra sua", "tra da", "my", "pho"]
categories.each do |category_name|
  category = Category.create(name: category_name)
  ElasticsearchClient.index(index: 'categories', id: category.id, body: { name: category_name })
end
50.times do |i|
  category = Category.order("RAND()").first
  product = Product.create!(
    name: "Product #{i + 1}", 
    price: Money.new(rand(100000..1000000), "VND"),
    delivery_quantity: rand(1..10),
    description: "Description for product",
    quantity_in_stock: rand(1..50),
    category: category
  )
  ElasticsearchClient.index(index: 'products', id: product.id, body: {
    name: product.name,
    price_cents: product.price_cents,
    currency: "VND",
    delivery_quantity: product.delivery_quantity,
    description: product.description,
    quantity_in_stock: product.quantity_in_stock,
    currency: product.price.currency,
    category: category.id 
  })
end
