-- ПОСМОТРЕТЬ, СКОЛЬКО ЗОЛОТЫХ БИЛЕТОВ ПРОДАНО

CREATE OR REPLACE FUNCTION UpdatePassword(
	_user_id INT,
	_login VARCHAR(20),
	_password VARCHAR(20)
)
RETURNS VOID AS
$BODY$	
	
	DECLARE
		_row RECORD;
	
	DECLARE
		my_cursor CURSOR FOR SELECT login, password, user_id FROM users;
		
	BEGIN

		FOR _row IN my_cursor
		LOOP
			UPDATE users
				SET login = _login, password = _password WHERE user_id = _user_id;
			EXIT WHEN NOT FOUND;
		END LOOP;

	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM users;
SELECT * FROM UpdatePassword(4, 'Ilya', '0');



DO $$
	DECLARE 
		my_cursor CURSOR FOR SELECT ticket_id FROM tickets WHERE code = 'GOLDEN_TICKET';
		rec TEXT;
	
	BEGIN
		OPEN my_cursor;
		
		FETCH NEXT FROM my_cursor INTO rec;

		WHILE FOUND
		LOOP
		   RAISE NOTICE '%', rec;
		   FETCH NEXT FROM my_cursor INTO rec;
		END LOOP;

		CLOSE my_cursor;
	END;
$$