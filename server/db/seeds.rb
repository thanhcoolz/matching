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

if Club.first.blank?
  20.times do
    puts "Creating club..."

    club = Club.new(
      email: Faker::Internet.email,
      name: Faker::Company.name,
      country_id: Country.all.sample.id,
      city_id: Country.all.sample.cities.sample.id,
      district_id: Country.all.sample.cities.sample.districts.sample.id,
      street_id: Country.all.sample.cities.sample.districts.sample.streets.sample.id,
      address: Faker::Address.street_address,
      description: Faker::Lorem.paragraph,
    )

    # Attach main image
    club.main_image.attach(
      io: File.open(Rails.root.join('db', 'fixtures', 'sample_club.jpg')),
      filename: 'main_image.jpg',
      content_type: 'image/jpeg'
    )

    # Attach 3 sub images
    3.times do |i|
      club.sub_images.attach(
        io: File.open(Rails.root.join('db', 'fixtures', 'sample_club.jpg')),
        filename: "sub_image_#{i + 1}.jpg",
        content_type: 'image/jpeg'
      )
    end

    club.save!

    10.times do
      club.club_managers.create!(
        username: Faker::Alphanumeric.unique.alpha(number: 10),
        password: "12341234",
      )
    end
  end
end

