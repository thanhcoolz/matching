if Admin.first.blank?
  Admin.create!(
    email: "admin@example.com",
    password: "12341234",
  )

  puts "Admin user created successfully."
end

if Country.first.blank?
  country = Country.create!(
    name: "Việt Nam",
  )

  puts "Country created successfully."

  country.cities.create!(
    name: "Hà Nội",
    districts_attributes: [
      {
        name: "Đống Đa",
        streets_attributes: [
          {
            name: "Cát Linh"
          },
          {
            name: "Chùa Bộc"
          },
          {
            name: "Chùa Láng"
          },
          {
            name: "Đại La"
          }
        ]
      },
      {
      name: "Hoàn Kiếm",
      streets_attributes: [
        {
          name: "Bát Đàn"
        },
        {
          name: "Cầu Gỗ"
        },
        {
          name: "Đinh Lễ"
        },
        {
          name: "Hai Bà Trưng"
        }
      ]
      }
    ],
  )

  puts "City, streets and districts created successfully."
end
