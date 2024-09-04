categories = ["com", "tra sua", "tra da", "my", "pho"]
categories.each do |category_name|
  Category.create(name: category_name)
end
2.times do |i|
  user = User.create!(
    email: "admin#{i + 1}@example.com",
    username: "admin#{i + 1}",
    password: "password",
    role: 0
  )
  user.create_cart!
end
18.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    username: "user#{i + 1}",
    password: "password",
    role: 1
  )
  user.create_cart!
end
50.times do |i|
  category = Category.order("RAND()").first
  product = Product.create!(
    name: "Product #{i + 1}",
    price: Money.new(rand(100000..1000000), "VND"),
    delivery_quantity: rand(1..10),
    description: "Description for product #{i + 1}",
    quantity_in_stock: rand(1..50),
    category: category
  )

  # Seed discount for product
  Discount.create!(
    product_id: product.id,
    discount_rate: rand(5.0..50.0).round(2), # Discount rate between 5% to 50%
    status: [0, 1].sample,
    start_time: Time.now - rand(1..30).days, # Random start time within the last 30 days
    end_time: Time.now + rand(1..30).days
  )
end
payment_methods = ["credit_card", "paypal", "bank_transfer"]
payment_methods.each do |method|
  PaymentMethod.create!(payment_method: method)
end
