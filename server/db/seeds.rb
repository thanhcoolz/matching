if Admin.first.blank?
  Admin.create!(
    email: "admin@example.com",
    password: "12341234",
  )

  puts "Admin user created successfully."
end
