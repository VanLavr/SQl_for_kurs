--------------------------------------------------------------------------------------------------------------------------------UPDATE VIEW
CREATE OR REPLACE FUNCTION updateview(
	oldTable ticket_for_user,
	newTable ticket_for_user
)
RETURNS VOID AS
$BODY$
	BEGIN
		UPDATE tickets
			SET price = newTable.price, code = newTable.code, flight = newTable.flight_id, passanger_id = newTable.user_id WHERE ticket_id = oldTable.ticket_id;
		UPDATE flights
			SET departure_city = newTable.departure_city, arrival_city = newTable.arrival_city WHERE flight_id = oldTable.flight_id;
		UPDATE users
			SET login = newTable.login WHERE user_id = oldTable.user_id;
	END;
$BODY$
LANGUAGE plpgsql;

CREATE RULE update_view AS
ON UPDATE TO ticket_for_user DO INSTEAD(
	SELECT updateview(OLD, NEW));

UPDATE ticket_for_user
	SET login = 'Dib' WHERE flight_id = 2;
--------------------------------------------------------------------------------------------------------------------------------UPDATE VIEW

--------------------------------------------------------------------------------------------------------------------------------INSERT VIEW
CREATE OR REPLACE FUNCTION insertview(
	newTable ticket_for_user
)
RETURNS VOID AS
$BODY$
	BEGIN
		INSERT INTO flights(departure_city, arrival_city) VALUES(newTable.departure_city, newTable.arrival_city);
		INSERT INTO tickets(price, code, flight, passanger_id) VALUES(newTable.price, newTable.code, newTable.flight_id, newTable.user_id);
		INSERT INTO users(login) VALUES(newTable.login);
	END;
$BODY$
LANGUAGE plpgsql;

CREATE RULE insert_view AS
ON INSERT TO ticket_for_user DO INSTEAD(
	SELECT insertview(NEW));
	
INSERT INTO ticket_for_user(price, code, departure_city, arrival_city, flight_id, user_id, login) VALUES(200, 'gold', 'Moscow', 'Ramenskoe', 14, 1, 'New');
--------------------------------------------------------------------------------------------------------------------------------INSERT VIEW

--------------------------------------------------------------------------------------------------------------------------------DELETE VIEW
CREATE OR REPLACE FUNCTION deletedatafromview(
	oldTable ticket_for_user
)
RETURNS VOID AS
$BODY$
	BEGIN
		DELETE FROM tickets WHERE ticket_id = oldTable.ticket_id;
		DELETE FROM flights WHERE flight_id = oldTable.flight_id;
		DELETE FROM users WHERE user_id = oldTable.user_id;
	END;
$BODY$
LANGUAGE plpgsql;

CREATE RULE deletedatafromview AS
ON DELETE TO ticket_for_user DO INSTEAD(
	SELECT deletedatafromview(OLD));

DELETE FROM ticket_for_user WHERE ticket_id = 34;
--------------------------------------------------------------------------------------------------------------------------------DELETE VIEW



UPDATE ticket_for_user
	SET login = 'Dib' WHERE flight_id = 2;




select * from ticket_for_user;

select * from tickets;
select * from users;
select * from flights;
