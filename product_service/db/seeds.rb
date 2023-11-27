# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Product.destroy_all

10.times do
    product = Product.new(
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price,
        description: "#{Faker::Commerce.department}\nBrand: #{Faker::Commerce.brand}\nMaterial: #{Faker::Commerce.material}" 
    )
    file_path = Rails.root.join("spec", "fixtures", "files", "image.png")
    product.images.attach(io: File.open(file_path), filename: "image.png")

    product.save!
end

p "Added #{Product.count} products"