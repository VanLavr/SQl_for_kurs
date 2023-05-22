SET enable_seqscan = OFF;
SET enable_indexscan = ON;

CREATE INDEX airplane_name_idx ON airplanes(airpale_name);
CREATE UNIQUE INDEX login_idx ON users(login);
CREATE UNIQUE INDEX port_idx ON airplanes(port_id);
CREATE INDEX fl_idx ON flights(flight_id);
CREATE INDEX tckt_idx ON tickets(price, flight, passanger_id);