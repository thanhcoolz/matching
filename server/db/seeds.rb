# Create admin if not exists
unless Admin.exists?
  Admin.create!(
    email: "admin@example.com",
    password: "12341234",
  )
  puts "Admin user created successfully."
end

# Create country and related data if not exists
unless Country.exists?
  ActiveRecord::Base.transaction do
    country = Country.create!(name: "Việt Nam")
    puts "Country created successfully."

    # Prepare districts and streets data
    districts_data = [
      {
        name: "Đống Đa",
        streets_attributes: [
          { name: "Cát Linh" },
          { name: "Chùa Bộc" },
          { name: "Chùa Láng" },
          { name: "Đại La" }
        ]
      },
      {
        name: "Hoàn Kiếm",
        streets_attributes: [
          { name: "Bát Đàn" },
          { name: "Cầu Gỗ" },
          { name: "Đinh Lễ" },
          { name: "Hai Bà Trưng" }
        ]
      }
    ]

    city = country.cities.create!(
      name: "Hà Nội",
      districts_attributes: districts_data
    )
    puts "City, streets and districts created successfully."
  end
end

# Create clubs if none exist
unless Club.exists?
  ActiveRecord::Base.transaction do
    # Pre-fetch all necessary data to avoid N+1 queries
    country = Country.first
    city = country.cities.first
    districts = city.districts.includes(:streets)

    # Prepare sample image files
    main_image_file = File.open(Rails.root.join('db', 'fixtures', 'sample_club.jpg'))
    sub_image_file = File.open(Rails.root.join('db', 'fixtures', 'sample_club.jpg'))

    # Create clubs in batches
    20.times do |i|
      puts "Creating club #{i + 1} of 20..."

      # Select random district and its street
      district = districts.sample
      street = district.streets.sample

      club = Club.new(
        email: Faker::Internet.unique.email,
        name: Faker::Company.unique.name,
        country_id: country.id,
        city_id: city.id,
        district_id: district.id,
        street_id: street.id,
        address: Faker::Address.unique.street_address,
        description: Faker::Lorem.paragraph
      )

      # Attach images with new file handles each time
      club.main_image.attach(
        io: File.open(Rails.root.join('db', 'fixtures', 'sample_club.jpg')),
        filename: "main_image_#{i}.jpg",
        content_type: 'image/jpeg'
      )

      3.times do |j|
        club.sub_images.attach(
          io: File.open(Rails.root.join('db', 'fixtures', 'sample_club.jpg')),
          filename: "sub_image_#{i}_#{j}.jpg",
          content_type: 'image/jpeg'
        )
      end

      club.save!

      10.times do
        club.club_managers.create!(
          username: Faker::Alphanumeric.unique.alpha(number: 10),
          password: "12341234"
        )
      end
    end
  end

  puts "Created 20 clubs with managers and images successfully."
end
