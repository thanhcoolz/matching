# Technical Stack Documentation

## Backend (Ruby on Rails API)

### Core Technologies

- Ruby 3.4.1
- Rails 7.1.5.1 (API Mode)
- MySQL Database
- Docker & Docker Compose

### Authentication & Security

- JWT (JSON Web Tokens) for authentication
- BCrypt for password hashing ( Rails already support this as default `has_secure_password` <https://api.rubyonrails.org/v7.1/classes/ActiveModel/SecurePassword/ClassMethods.html> )
- CORS configuration for cross-origin requests ( cors.rb )
- Role-based authorization (Admin, Club Manager, User)
  - Admin routes definitions in `adminRoutes.js`
  - Club Manager routes definitions in `clubRoutes.js`
  - User routes definitions in `userRoutes.js`

### Database Management

- Ridgepole for database schema management `server/db/schemas/*.schema`
- Active Record for ORM ( Object-Relational Mapping ), this is an object that map from ruby object to database's table
- MySQL as primary database

### File Storage

- ***Active Storage*** for file uploads ( <https://guides.rubyonrails.org/active_storage_overview.html> )

### API Features

- RESTful API design ( <https://topdev.vn/blog/restful-api-la-gi/> )
- JSON response
- Pagination using Pagy gem (<https://github.com/ddnexus/pagy>)
- Error handling and status codes ( follow the convention <https://restfulapi.net/http-status-codes/> )
- API versioning (namespace: /api/v1) ( want to do but doesnt have time )

### Development Tools

- `Annotate` for model annotations ( <https://github.com/ctran/annotate_models> )
- `Faker` for seed data generation ( <https://github.com/faker-ruby/faker> )

## Frontend (Vue.js)

### Core Technologies

- Vue.js 3.5.13
- Vite.js as build tool
- Vue Router 4.5.0 for routing

### UI/UX

- TailwindCSS for styling
- Responsive design

### Features

- Route guards for authentication
- Modular routing system, seperated routes for each user target
  - /admin: for admin
  - /club: for club manager
  - /: for user

### Development Tools

- `Axios` for HTTP requests ( <https://github.com/axios/axios> )
- `Lodash` for utility functions ( <https://lodash.com/> )

## DevOps & Infrastructure

### Containerization

- Docker and docker-compose for easy development across multiple OS and deployment ( <https://www.docker.com/> )

### Version Control

- Git for version control

## Architecture Patterns

### Backend

- MVC (Model-View-Controller) pattern
- RESTful API design
- Modular routing system, seperated routes for each user target
  - /admin: for admin
  - /club: for club manager
  - /: for user
