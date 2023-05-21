-- dont forget to create indexes!!!!!
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	login VARCHAR(20),
	password VARCHAR(20)
);
SELECT * FROM users;

-- dont forget to create !trigger! and !view! after creating this table!!!
CREATE TABLE tickets(
	ticket_id SERIAL PRIMARY KEY,
	price FLOAT,
	code TEXT,
	flight INT REFERENCES flights(flight_id),
	passanger_id INT REFERENCES users(user_id)
);
SELECT * FROM tickets;

CREATE TABLE flights(
	flight_id SERIAL PRIMARY KEY,
	departure_date TIMESTAMP,
	arrival_date TIMESTAMP,
	departure_city VARCHAR(30),
	arrival_city VARCHAR(30),
	airplane_id INT REFERENCES airplanes(airplane_id)
);
SELECT * FROM flights;

CREATE TABLE airplanes(
	airplane_id SERIAL PRIMARY KEY,
	airpale_name VARCHAR(30),
	seats INT,
	reserved_seats INT,
	port_id TEXT
);
SELECT * FROM airplanes;

---------------------------- DROPPIN
DROP TABLE tickets CASCADE;
DROP TABLE users;
DROP TABLE flights;
DROP TABLE airplanes;
---------------------------- DROPPIN
TRUNCATE TABLE tickets;