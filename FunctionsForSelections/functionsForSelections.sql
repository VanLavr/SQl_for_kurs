/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

это будет выводиться (в таком формате) как табличка с доступными рейсами на странице поиска
(для пользователя)

   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
CREATE OR REPLACE FUNCTION all_flight_info()
RETURNS TABLE (
	_departure_date TIMESTAMP,
	_arrival_date TIMESTAMP,
	_departure_city VARCHAR(30),
	_arrival_city VARCHAR(30),
	_airpale_name VARCHAR(30),
	is_full BOOLEAN,
	_flight_id INT
) AS
$BODY$
	BEGIN
		RETURN QUERY 
			SELECT departure_date, arrival_date, departure_city, arrival_city, airpale_name,
				CASE WHEN airplanes.seats - airplanes.reserved_seats = 0 THEN TRUE ELSE FALSE END AS is_full, flights.flight_id
					FROM flights JOIN airplanes ON airplanes.airplane_id = flights.airplane_id;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM all_flight_info();
------------------------------------------- COMPILED MULTITABLE REQUEST WITH 'CASE' EXPRESSION -------------------------------------------


/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

это будет выводиться (в таком формате) как табличка с купленными билетами на рейсы на страничке
редактирования в разделе редактирования билетов пользователей для администратора

   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
CREATE OR REPLACE VIEW ticket_info AS -- PRICE, DEP CITY, ARR CITY, USERNAME
	SELECT departure_city, arrival_city, price, login FROM flights INNER JOIN
		tickets ON flights.flight_id = tickets.flight INNER JOIN
			users ON users.user_id = tickets.passanger_id;

SELECT * FROM ticket_info;
------------------------------------------- MULTITABLE VIEW REQUEST WITH TWO INNER JOINS -------------------------------------------


/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет выводиться как дорогостоящие билеты на рейсы во вкладке "бизнес класс" на страничке 
поиска, для пользователя
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT * FROM tickets WHERE price > (
	SELECT AVG(price) FROM tickets
);

-- CORRELATED 1
SELECT AI.airpale_name, AI.reserved_seats, AI.port_id FROM airplanes AI WHERE EXISTS (
	SELECT port_id FROM flights f WHERE f.airplane_id = AI.airplane_id
);

-- CORRELATED 2
SELECT (SELECT login FROM users U WHERE U.user_id = TC.passanger_id), price FROM tickets TC;

-- CORRELATED 3
CREATE OR REPLACE FUNCTION flights_for_admin()
RETURNS TABLE (
	_departure_date TIMESTAMP,
	_arrival_date TIMESTAMP,
	_departure_city VARCHAR(30),
	_arrival_city VARCHAR(30),
	_airplane_port TEXT,
	_flight_id INT
) AS
$BODY$
	BEGIN
		RETURN QUERY 
			SELECT departure_date, arrival_date, departure_city, arrival_city, (
				SELECT AI.port_id FROM airplanes AI WHERE AI.airplane_id = FL.airplane_id
			), flight_id FROM flights FL;
	END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM flights_for_admin();

/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет использоваться для выявления популярного рейса во вкладке "популярные направления" 
или "успейте купить" (где ещё есть места) но много занятых мест в самолёте, для пользователя
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT * FROM airplanes WHERE reserved_seats > (
	SELECT AVG(reserved_seats) FROM airplanes
) AND reserved_seats != seats;

/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет выводиться во вкладке "быстрые рейсы" (тут только рейсы, которые длятся меньше среднего)
для пользователя
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT * FROM flights WHERE arrival_date - departure_date < (
	SELECT AVG(arrival_date - departure_date) FROM flights
);

--SELECT EXTRACT(HOUR FROM (arrival_date - departure_date)) FROM flights AS day_diff;
------------------------------------------- CORRELATED REQUESTS -------------------------------------------


-- количество юзеров, которые купили билет за цену, больше средней | спросить в субботу у Дмитрия Саныча про то, можно ли запихнуть этот запро во вью, чтобы было удобнее его дёргать с сервера
/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
будет выводиться во вкладке настроек у администратора с подписью "буржуи"
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT COUNT(user_id) AS buisiness_class FROM users JOIN tickets ON tickets.passanger_id = users.user_id
	GROUP BY price
		HAVING price >= (SELECT AVG(price) FROM tickets);
------------------------------------------- HAVING REQUEST -------------------------------------------


/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет выводиться как названия самых больших самолётов во вкладке "интересное" или "о нас"
для пользователей
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT airpale_name FROM airplanes WHERE seats > (
	SELECT AVG(seats) FROM airplanes
);

/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет выводиться во вкладке "вылеты" для пользователя
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT * FROM (
	SELECT departure_date, arrival_date, departure_city, arrival_city FROM flights
) AS flights;

/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет выводиться во вкладке "статистика по занятости самолётов" для администратора
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT airpale_name,
	(SELECT COUNT(airplane_id) FROM flights WHERE flights.airplane_id = airplanes.airplane_id)
FROM airplanes;
------------------------------------------- SUBQUERY REQUEST (SELECT, FROM, WHERE) -------------------------------------------

-- вывести на экран билеты если в таблице есть билеты на тот же рейс
/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет выводиться для администратора во вкладке "конкурентные билеты"
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT ticket_id, price, flight, passanger_id
	FROM tickets tckt
	WHERE flight = ANY(
		SELECT flight FROM tickets tckt1 WHERE tckt != tckt1
	);

-- вывести на экран с помощью SELECT все билеты, где цена превышает цену каждого билета на 3 рейс
/* 
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
это будет во вкладке "настрйки" для администратора, для того, чтобы можно было сравнить цену 
билетов на все рейсы с ценой билета на какой-то конкретный рейс
   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
*/
SELECT *
	FROM tickets
	WHERE price > ALL(
		SELECT price FROM tickets WHERE flight = 3
	);
------------------------------------------- PREDICAT REQUEST (ANY, ALL) -------------------------------------------


-- пробуем вытащить номер билета, зная номер рейса
SELECT ticket_id, flight_id
	FROM tickets JOIN flights ON 
		tickets.flight = flights.flight_id;


------------------------------------------- TICKET INFO FOR CLIENT -------------------------------------------
CREATE OR REPLACE VIEW ticket_for_user AS
SELECT price, code, departure_city, arrival_city, flight_id, user_id FROM tickets JOIN flights
	ON tickets.flight = flights.flight_id JOIN users 
		ON tickets.passanger_id = users.user_id;

SELECT * FROM ticket_for_user;

UPDATE ticket_for_user
	SET price = 1000 WHERE price = 500;




------------------------------------------- TICKET INFO FOR CLIENT -------------------------------------------
CREATE OR REPLACE VIEW ticket_for_user AS
SELECT price, code, departure_city, arrival_city, user_id, flights.flight_id FROM tickets JOIN flights
	ON tickets.flight = flights.flight_id JOIN users
		ON tickets.passanger_id = users.user_id;
