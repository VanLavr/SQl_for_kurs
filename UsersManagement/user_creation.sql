SELECT user;
SELECT * FROM pg_user;
SELECT * FROM pg_settings WHERE name = 'port';

CREATE USER default_user WITH PASSWORD '12345678';
GRANT INSERT, DELETE ON tickets TO default_user;
GRANT SELECT(login, password, user_id), INSERT, UPDATE, DELETE ON users TO default_user;
GRANT SELECT ON flights, airplanes TO default_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO default_user;
GRANT SELECT(ticket_id, flight, passanger_id) ON tickets TO default_user;
GRANT SELECT ON ticket_for_user TO default_user;

CREATE USER administrator WITH PASSWORD 'qwerty';
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON tickets TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON users TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON flights TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON airplanes TO Administrator;
GRANT SELECT, INSERT, UPDATE, DELETE ON ticket_for_user TO Administrator;

/*
строка подключения через консоль следующая:
psql -U postgres (затем пароль)
ЛИБО
psql -U postgres kurs; где kurs - название базы, к которой хотим подключиться
затем также пароль.
если пытаться подключиться с дефолт_усера, то выскакивает ошибка, что нет базы такой, хотя с постгресом нет такой ошибки...
\c <dataBaseName>
\q
\dt
\l - список существующих БД
create database "название БД"; - создание БД
\connect "название БД" - подключение к БД
\dt - показывает существующие в БД таблицы
psql \! chcp 1251 - корректное отображение кирилиццы
*/