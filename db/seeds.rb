puts "🌱 Seeding spices..."

# Seed your database here

User.create({
    name: "Kamau",
    email: "kamau@wanjoroge.com",
    phone: "254723987432",
    password: "Jsjdof jsdifjsodifjsdf",
    avatar: Faker::LoremFlickr.image(size:"50x50", search_terms: ["person"])
});

puts "✅ Done seeding!"
