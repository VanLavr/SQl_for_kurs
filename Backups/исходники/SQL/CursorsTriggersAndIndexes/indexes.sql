SET enable_seqscan = OFF;
SET enable_indexscan = ON;
EXPLAIN analyze SELECT reserved_seats FROM airplanes where reserved_seats = 1;
EXPLAIN SELECT airpale_name FROM airplanes WHERE airpale_name = 'Airbus A380';
EXPLAIN SELECT airpale_name FROM airplanes WHERE airpale_name LIKE '%Airbus%';
EXPLAIN SELECT * FROM users WHERE login = 'Kolya';

CREATE INDEX airplane_name_idx ON airplanes(airpale_name);
CREATE UNIQUE INDEX login_idx ON users(login);
CREATE UNIQUE INDEX port_idx ON airplanes(port_id);
CREATE INDEX fl_idx ON flights(flight_id);

CREATE INDEX price_idx ON tickets USING hash (price);
CREATE INDEX reserved_seats_idx ON airplanes USING hash (reserved_seats);
CREATE EXTENSION pg_trgm;
CREATE INDEX log_idx ON users USING gin (login gin_trgm_ops);