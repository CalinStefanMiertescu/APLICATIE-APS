CREATE TABLE cities (
  city_id SERIAL PRIMARY KEY,
  city_name VARCHAR(100) NOT NULL
);

CREATE TABLE publications (
  publication_id SERIAL PRIMARY KEY,
  publication_name VARCHAR(100) NOT NULL
);

CREATE TABLE journalist_types (
  journalist_type_id SERIAL PRIMARY KEY,
  journalist_type_name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  surname VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  city_id INT REFERENCES cities(city_id),
  phone VARCHAR(20),
  email VARCHAR(100) UNIQUE NOT NULL,
  email_verified BOOLEAN DEFAULT FALSE,
  journalist_type_id INT REFERENCES journalist_types(journalist_type_id),
  publication_id INT REFERENCES publications(publication_id),
  status VARCHAR(20) DEFAULT 'waiting_for_confirmation' CHECK (status IN ('active', 'inactive', 'waiting_for_confirmation')),
  membership_status VARCHAR(20) CHECK (membership_status IN ('paying', 'non_paying')),
  membership_expiry DATE,
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admins (
  admin_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) NOT NULL CHECK (role IN ('SuperAdmin', 'Admin')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE announcements (
  announcement_id SERIAL PRIMARY KEY,
  admin_id INT REFERENCES admins(admin_id) ON DELETE SET NULL,
  title VARCHAR(200) NOT NULL,
  body TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE membership_requests (
  request_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  admin_id INT REFERENCES admins(admin_id) ON DELETE SET NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('approved', 'rejected', 'pending')),
  request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  review_date TIMESTAMP
);