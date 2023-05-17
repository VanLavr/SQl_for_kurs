CREATE OR REPLACE FUNCTION data_insertion_for_airplanes(
	_seats INT,
	_reserved_seats INT,
	_airpale_name VARCHAR(30)
)
RETURNS VOID AS 
$BODY$
	BEGIN
		INSERT INTO airplanes(seats, reserved_seats, airpale_name)
			VALUES (_seats, _reserved_seats, _airpale_name);
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM data_insertion_for_airplanes(853, 511, 'Airbus A380');
SELECT * FROM data_insertion_for_airplanes(110, 27, 'Boeing 737');
SELECT * FROM data_insertion_for_airplanes(440, 150, 'Airbus A350');
SELECT * FROM data_insertion_for_airplanes(375, 11, 'Airbus A340');
SELECT * FROM data_insertion_for_airplanes(467, 327, 'Boeing 747');
SELECT * FROM data_insertion_for_airplanes(10, 3, 'AN-2P');
------------------------------------------- ADD DATA TO AIRPLANES TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION delete_data_from_airplanes(_airplane_id INT)
RETURNS VOID AS
$BODY$
	BEGIN
		DELETE FROM airplanes WHERE airplane_id = _airplane_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM delete_data_from_airplanes(6);
------------------------------------------- DELETE DATA FROM AIRPLANES TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION update_data_for_airplanes(
	_airplane_id INT,
	_seats INT,
	_reserved_seats INT,
	_airpale_name VARCHAR(30)
)
RETURNS VOID AS
$BODY$
	BEGIN
		UPDATE airplanes
			SET seats = _seats, reserved_seats = _reserved_seats, airpale_name = _airpale_name WHERE airplane_id = _airplane_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM update_data_for_airplanes(7, 16, 3, 'AN-2M');
------------------------------------------- UPDATE DATA FOR AIRPLANES TABLE -------------------------------------------


CREATE OR REPLACE PROCEDURE data_insertion_for_tickets(
	_price FLOAT,
	_flight INT,
	_passanger_id INT
) AS
$BODY$
	DECLARE
		_id_for_flight INT;
		_id_for_passanger INT;
	
	BEGIN		
		SELECT flight_id INTO _id_for_flight FROM flights WHERE flight_id = _flight;
		SELECT user_id INTO _id_for_passanger FROM users WHERE user_id = _passanger_id;
		
		IF _id_for_flight IS NOT NULL AND _id_for_passanger IS NOT NULL THEN
			INSERT INTO tickets(price, flight, passanger_id)
				VALUES (_price, _flight, _passanger_id);
			COMMIT;
		ELSE
			ROLLBACK;
		END IF;
	END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION data_insertion_for_tickets_func(
	_price FLOAT,
	_flight INT,
	_passanger_id INT
)
RETURNS VOID AS 
$BODY$
	BEGIN
		INSERT INTO tickets(price, flight, passanger_id)
			VALUES (_price, _flight, _passanger_id);
	END;
$BODY$
LANGUAGE plpgsql;

CALL data_insertion_for_tickets(1210.50, 1, 1);
CALL data_insertion_for_tickets(990.25, 2, 2);
CALL data_insertion_for_tickets(500.0, 3, 2);
CALL data_insertion_for_tickets(200.99, 4, 2);
CALL data_insertion_for_tickets(255.99, 1, 1);
CALL data_insertion_for_tickets(255.99, 1, 5);
------------------------------------------- ADD DATA TO TICKETS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION delete_data_from_tickets(_ticket_id INT)
RETURNS VOID AS 
$BODY$
	BEGIN
		DELETE FROM tickets WHERE ticket_id = _ticket_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM delete_data_from_tickets(1);
------------------------------------------- DELETE DATA FROM TICKETS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION update_data_for_tickets(
	_ticket_id INT,
	_price FLOAT,
	_flight INT,
	_passanger_id INT
)
RETURNS VOID AS
$BODY$
	BEGIN
		UPDATE tickets 
			SET price = _price, flight = _flight, passanger_id = _passanger_id WHERE ticket_id = _ticket_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM update_data_for_tickets(5, 302.78, 4, 1);
------------------------------------------- UPDATE DATA FOR TICKETS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION add_user(
	_login VARCHAR(20),
	_password VARCHAR(20)
)
RETURNS VOID AS
$BODY$
	BEGIN
		INSERT INTO users(login, password)
			VALUES (_login, _password);
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM add_user('Nikita', 'qwerty228');
SELECT * FROM add_user('Nikitaaaaa', 'qwerty228');
SELECT * FROM add_user('Ivan', 'POIUYT322');
------------------------------------------- ADD DATA TO USERS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION delete_data_from_users(_user_id INT)
RETURNS VOID AS 
$BODY$
	BEGIN
		DELETE FROM users CASCADE WHERE user_id = _user_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM delete_data_from_users(7);
------------------------------------------- DELETE DATA FROM USERS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION update_data_for_users(
	_user_id INT,
	_login VARCHAR(20),
	_password VARCHAR(20)
)
RETURNS VOID AS
$BODY$
	BEGIN
		UPDATE users 
			SET login = _login, password = _password WHERE user_id = _user_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM update_data_for_users(1, 'Nikita Chupin', '123456');
------------------------------------------- UPDATE DATA FOR USERS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION add_flight(
	_departure_date TIMESTAMP,
	_arrival_date TIMESTAMP,
	_departure_city VARCHAR(30),
	_arrival_city VARCHAR(30),
	_id INT
)
RETURNS VOID AS
$BODY$
	BEGIN
		INSERT INTO flights(departure_date, arrival_date, departure_city, arrival_city, airplane_id)
			VALUES (_departure_date, _arrival_date, _departure_city, _arrival_city, _id);
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM add_flight('2023-06-04 20:40:00', '2023-06-04 23:55:00', 'Amsterdam', 'Moscow', 5);
SELECT * FROM add_flight('2023-06-11 07:25:00', '2023-06-11 11:00:00', 'Moscow', 'Paris', 2);
SELECT * FROM add_flight('2023-11-28 15:30:00', '2023-11-28 19:15:00', 'London', 'Walles', 4);
SELECT * FROM add_flight('2023-11-18 12:10:00', '2023-11-18 15:55:00', 'Kishenev', 'London', 7);
SELECT * FROM add_flight('2023-12-23 10:00:00', '2023-12-24 12:30:00', 'Singapour', 'New-York', 1);
SELECT * FROM add_flight('2023-12-28 17:05:00', '2023-12-29 16:20:00', 'St. Petersberg', 'Santafe', 3);
------------------------------------------- ADD DATA TO FLIGHTS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION delete_data_from_flights(_flight_id INT)
RETURNS VOID AS 
$BODY$
	BEGIN
		DELETE FROM flights WHERE flight_id = _flight_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM delete_data_from_flights(3);
------------------------------------------- DELETE DATA FROM FLIGHTS TABLE -------------------------------------------


CREATE OR REPLACE FUNCTION update_data_for_flights(
	_flight_id INT,
	_departure_date TIMESTAMP,
	_arrival_date TIMESTAMP,
	_departure_city VARCHAR(30),
	_arrival_city VARCHAR(30),
	_airplane_id INT
)
RETURNS VOID AS
$BODY$
	BEGIN
		UPDATE flights 
			SET departure_date = _departure_date, arrival_date = _arrival_date, departure_city = _departure_city, arrival_city = _arrival_city, airplane_id = _airplane_id WHERE flight_id = _flight_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM update_data_for_flights(7, '2023-11-28 15:30:00', '2023-11-28 19:15:00', 'Limassol', 'Walles', 4);
------------------------------------------- UPDATE DATA FOR FLIGHTS TABLE -------------------------------------------