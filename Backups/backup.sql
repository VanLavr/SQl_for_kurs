PGDMP     3            
        {            kurs    15.2    15.2 [               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16399    kurs    DATABASE     x   CREATE DATABASE kurs WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE kurs;
                postgres    false                        3079    49915    pg_trgm 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
    DROP EXTENSION pg_trgm;
                   false            �           0    0    EXTENSION pg_trgm    COMMENT     e   COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';
                        false    2            �           1247    16504    result_all_flights    TYPE     �   CREATE TYPE public.result_all_flights AS (
	_departure_date timestamp without time zone,
	_arrival_date timestamp without time zone,
	_departure_city character varying(30),
	_arrival_city character varying(30),
	_id_airplane integer,
	is_full boolean
);
 %   DROP TYPE public.result_all_flights;
       public          postgres    false            !           1255    50144 p   add_flight(timestamp without time zone, timestamp without time zone, character varying, character varying, text)    FUNCTION       CREATE FUNCTION public.add_flight(_departure_date timestamp without time zone, _arrival_date timestamp without time zone, _departure_city character varying, _arrival_city character varying, _port_id text) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		_id INT;

	BEGIN
		SELECT airplane_id INTO _id FROM airplanes WHERE _port_id = port_id;
	
		INSERT INTO flights(departure_date, arrival_date, departure_city, arrival_city, airplane_id)
			VALUES (_departure_date, _arrival_date, _departure_city, _arrival_city, _id);
	END;
$$;
 �   DROP FUNCTION public.add_flight(_departure_date timestamp without time zone, _arrival_date timestamp without time zone, _departure_city character varying, _arrival_city character varying, _port_id text);
       public          postgres    false            �            1255    16451 .   add_user(character varying, character varying)    FUNCTION     �   CREATE FUNCTION public.add_user(_login character varying, _password character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO users(login, password)
			VALUES (_login, _password);
	END;
$$;
 V   DROP FUNCTION public.add_user(_login character varying, _password character varying);
       public          postgres    false                       1255    25334    all_flight_info()    FUNCTION     r  CREATE FUNCTION public.all_flight_info() RETURNS TABLE(_departure_date timestamp without time zone, _arrival_date timestamp without time zone, _departure_city character varying, _arrival_city character varying, _airpale_name character varying, is_full boolean, _flight_id integer)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY 
			SELECT departure_date, arrival_date, departure_city, arrival_city, airpale_name,
				CASE WHEN airplanes.seats - airplanes.reserved_seats = 0 THEN TRUE ELSE FALSE END AS is_full, flights.flight_id
					FROM flights JOIN airplanes ON airplanes.airplane_id = flights.airplane_id;
	END;
$$;
 (   DROP FUNCTION public.all_flight_info();
       public          postgres    false                       1255    16939 	   cursor1()    FUNCTION     �  CREATE FUNCTION public.cursor1() RETURNS text
    LANGUAGE plpgsql
    AS $$
	DECLARE 
		my_cursor CURSOR FOR SELECT code, ticket_id FROM tickets WHERE code = 'GOLDEN_TICKET';
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
		
		RETURN rec;
	END;
$$;
     DROP FUNCTION public.cursor1();
       public          postgres    false            �            1255    16553 A   data_insertion_for_airplanes(integer, integer, character varying)    FUNCTION     ,  CREATE FUNCTION public.data_insertion_for_airplanes(_seats integer, _reserved_seats integer, _airpale_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO airplanes(seats, reserved_seats, airpale_name)
			VALUES (_seats, _reserved_seats, _airpale_name);
	END;
$$;
 }   DROP FUNCTION public.data_insertion_for_airplanes(_seats integer, _reserved_seats integer, _airpale_name character varying);
       public          postgres    false                       1255    33577 G   data_insertion_for_airplanes(integer, integer, character varying, text)    FUNCTION     N  CREATE FUNCTION public.data_insertion_for_airplanes(_seats integer, _reserved_seats integer, _airpale_name character varying, _port_id text) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO airplanes(seats, reserved_seats, airpale_name, port_id)
			VALUES (_seats, _reserved_seats, _airpale_name, _port_id);
	END;
$$;
 �   DROP FUNCTION public.data_insertion_for_airplanes(_seats integer, _reserved_seats integer, _airpale_name character varying, _port_id text);
       public          postgres    false                       1255    16991 >   data_insertion_for_tickets(double precision, integer, integer) 	   PROCEDURE     ^  CREATE PROCEDURE public.data_insertion_for_tickets(IN _price double precision, IN _flight integer, IN _passanger_id integer)
    LANGUAGE plpgsql
    AS $$
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
$$;
 |   DROP PROCEDURE public.data_insertion_for_tickets(IN _price double precision, IN _flight integer, IN _passanger_id integer);
       public          postgres    false                       1255    25335 C   data_insertion_for_tickets_func(double precision, integer, integer)    FUNCTION       CREATE FUNCTION public.data_insertion_for_tickets_func(_price double precision, _flight integer, _passanger_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO tickets(price, flight, passanger_id)
			VALUES (_price, _flight, _passanger_id);
	END;
$$;
 w   DROP FUNCTION public.data_insertion_for_tickets_func(_price double precision, _flight integer, _passanger_id integer);
       public          postgres    false                       1255    41720 E   data_insertion_for_tickets_scalar(double precision, integer, integer)    FUNCTION     _  CREATE FUNCTION public.data_insertion_for_tickets_scalar(_price double precision, _flight integer, _passanger_id integer DEFAULT '-1'::integer, OUT res integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO tickets(price, flight, passanger_id)
			VALUES (_price, _flight, _passanger_id)
		RETURNING ticket_id INTO res;
	END;
$$;
 �   DROP FUNCTION public.data_insertion_for_tickets_scalar(_price double precision, _flight integer, _passanger_id integer, OUT res integer);
       public          postgres    false                       1255    16602 #   delete_data_from_airplanes(integer)    FUNCTION     �   CREATE FUNCTION public.delete_data_from_airplanes(_airplane_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM airplanes WHERE airplane_id = _airplane_id;
	END;
$$;
 G   DROP FUNCTION public.delete_data_from_airplanes(_airplane_id integer);
       public          postgres    false                       1255    33659     delete_data_from_airplanes(text)    FUNCTION     �   CREATE FUNCTION public.delete_data_from_airplanes(_port_id text) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM airplanes WHERE port_id = _port_id;
	END;
$$;
 @   DROP FUNCTION public.delete_data_from_airplanes(_port_id text);
       public          postgres    false            �            1255    16609 !   delete_data_from_flights(integer)    FUNCTION     �   CREATE FUNCTION public.delete_data_from_flights(_flight_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM flights WHERE flight_id = _flight_id;
	END;
$$;
 C   DROP FUNCTION public.delete_data_from_flights(_flight_id integer);
       public          postgres    false            �            1255    16605 !   delete_data_from_tickets(integer)    FUNCTION     �   CREATE FUNCTION public.delete_data_from_tickets(_ticket_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM tickets WHERE ticket_id = _ticket_id;
	END;
$$;
 C   DROP FUNCTION public.delete_data_from_tickets(_ticket_id integer);
       public          postgres    false            �            1255    16607    delete_data_from_users(integer)    FUNCTION     �   CREATE FUNCTION public.delete_data_from_users(_user_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM users CASCADE WHERE user_id = _user_id;
	END;
$$;
 ?   DROP FUNCTION public.delete_data_from_users(_user_id integer);
       public          postgres    false            �            1259    50076    flights    TABLE     !  CREATE TABLE public.flights (
    flight_id integer NOT NULL,
    departure_date timestamp without time zone,
    arrival_date timestamp without time zone,
    departure_city character varying(30),
    arrival_city character varying(30),
    airplane_id integer,
    unique_string text
);
    DROP TABLE public.flights;
       public         heap    postgres    false            �           0    0    TABLE flights    ACL     �   GRANT SELECT ON TABLE public.flights TO default_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flights TO administrator;
          public          postgres    false    221            �            1259    50090    tickets    TABLE     �   CREATE TABLE public.tickets (
    ticket_id integer NOT NULL,
    price double precision,
    code text,
    flight integer,
    passanger_id integer
);
    DROP TABLE public.tickets;
       public         heap    postgres    false            �           0    0    TABLE tickets    ACL     �   GRANT INSERT,DELETE ON TABLE public.tickets TO default_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tickets TO administrator;
          public          postgres    false    223            �           0    0    COLUMN tickets.ticket_id    ACL     A   GRANT SELECT(ticket_id) ON TABLE public.tickets TO default_user;
          public          postgres    false    223    3461            �           0    0    COLUMN tickets.flight    ACL     >   GRANT SELECT(flight) ON TABLE public.tickets TO default_user;
          public          postgres    false    223    3461            �           0    0    COLUMN tickets.passanger_id    ACL     D   GRANT SELECT(passanger_id) ON TABLE public.tickets TO default_user;
          public          postgres    false    223    3461            �            1259    50059    users    TABLE     �   CREATE TABLE public.users (
    user_id integer NOT NULL,
    login character varying(20),
    password character varying(20) DEFAULT '123'::character varying
);
    DROP TABLE public.users;
       public         heap    postgres    false            �           0    0    TABLE users    ACL     �   GRANT INSERT,DELETE,UPDATE ON TABLE public.users TO default_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO administrator;
          public          postgres    false    217            �           0    0    COLUMN users.user_id    ACL     =   GRANT SELECT(user_id) ON TABLE public.users TO default_user;
          public          postgres    false    217    3465            �           0    0    COLUMN users.login    ACL     ;   GRANT SELECT(login) ON TABLE public.users TO default_user;
          public          postgres    false    217    3465            �           0    0    COLUMN users.password    ACL     >   GRANT SELECT(password) ON TABLE public.users TO default_user;
          public          postgres    false    217    3465            �            1259    50113    ticket_for_user    VIEW     x  CREATE VIEW public.ticket_for_user AS
 SELECT tickets.price,
    tickets.code,
    flights.departure_city,
    flights.arrival_city,
    flights.flight_id,
    users.user_id,
    users.login,
    tickets.ticket_id
   FROM ((public.tickets
     JOIN public.flights ON ((tickets.flight = flights.flight_id)))
     JOIN public.users ON ((tickets.passanger_id = users.user_id)));
 "   DROP VIEW public.ticket_for_user;
       public          postgres    false    223    223    223    223    223    221    221    221    217    217            �           0    0    TABLE ticket_for_user    ACL     �   GRANT SELECT ON TABLE public.ticket_for_user TO default_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ticket_for_user TO administrator;
          public          postgres    false    225            $           1255    50121 *   deletedatafromview(public.ticket_for_user)    FUNCTION     6  CREATE FUNCTION public.deletedatafromview(oldtable public.ticket_for_user) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM tickets WHERE ticket_id = oldTable.ticket_id;
		DELETE FROM flights WHERE flight_id = oldTable.flight_id;
		DELETE FROM users WHERE user_id = oldTable.user_id;
	END;
$$;
 J   DROP FUNCTION public.deletedatafromview(oldtable public.ticket_for_user);
       public          postgres    false    225                       1255    41714    flights_for_admin()    FUNCTION     �  CREATE FUNCTION public.flights_for_admin() RETURNS TABLE(_departure_date timestamp without time zone, _arrival_date timestamp without time zone, _departure_city character varying, _arrival_city character varying, _airplane_port text, _flight_id integer)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY 
			SELECT departure_date, arrival_date, departure_city, arrival_city, (
				SELECT AI.port_id FROM airplanes AI WHERE AI.airplane_id = FL.airplane_id
			), flight_id FROM flights FL;
	END;
$$;
 *   DROP FUNCTION public.flights_for_admin();
       public          postgres    false                       1255    16730    generate_code()    FUNCTION     �   CREATE FUNCTION public.generate_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF NEW.ticket_id % 10 = 0 THEN
			NEW.code = 'GOLDEN_TICKET';
			NEW.PRICE = 1.0;
		ELSE
			NEW.code = 'default_ticket';
		END IF;
		RETURN NEW;
	END;
$$;
 &   DROP FUNCTION public.generate_code();
       public          postgres    false            #           1255    50119 "   insertview(public.ticket_for_user)    FUNCTION     �  CREATE FUNCTION public.insertview(newtable public.ticket_for_user) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO flights(departure_city, arrival_city) VALUES(newTable.departure_city, newTable.arrival_city);
		INSERT INTO tickets(price, code, flight, passanger_id) VALUES(newTable.price, newTable.code, newTable.flight_id, newTable.user_id);
		INSERT INTO users(login) VALUES(newTable.login);
	END;
$$;
 B   DROP FUNCTION public.insertview(newtable public.ticket_for_user);
       public          postgres    false    225            �            1255    16604 G   update_data_for_airplanes(integer, integer, integer, character varying)    FUNCTION     Y  CREATE FUNCTION public.update_data_for_airplanes(_airplane_id integer, _seats integer, _reserved_seats integer, _airpale_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE airplanes
			SET seats = _seats, reserved_seats = _reserved_seats, airpale_name = _airpale_name WHERE airplane_id = _airplane_id;
	END;
$$;
 �   DROP FUNCTION public.update_data_for_airplanes(_airplane_id integer, _seats integer, _reserved_seats integer, _airpale_name character varying);
       public          postgres    false                       1255    33642 D   update_data_for_airplanes(text, integer, integer, character varying)    FUNCTION     J  CREATE FUNCTION public.update_data_for_airplanes(_port_id text, _seats integer, _reserved_seats integer, _airpale_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE airplanes
			SET seats = _seats, reserved_seats = _reserved_seats, airpale_name = _airpale_name WHERE port_id = _port_id;
	END;
$$;
 �   DROP FUNCTION public.update_data_for_airplanes(_port_id text, _seats integer, _reserved_seats integer, _airpale_name character varying);
       public          postgres    false                       1255    16610 �   update_data_for_flights(integer, timestamp without time zone, timestamp without time zone, character varying, character varying, integer)    FUNCTION       CREATE FUNCTION public.update_data_for_flights(_flight_id integer, _departure_date timestamp without time zone, _arrival_date timestamp without time zone, _departure_city character varying, _arrival_city character varying, _airplane_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE flights 
			SET departure_date = _departure_date, arrival_date = _arrival_date, departure_city = _departure_city, arrival_city = _arrival_city, airplane_id = _airplane_id WHERE flight_id = _flight_id;
	END;
$$;
 �   DROP FUNCTION public.update_data_for_flights(_flight_id integer, _departure_date timestamp without time zone, _arrival_date timestamp without time zone, _departure_city character varying, _arrival_city character varying, _airplane_id integer);
       public          postgres    false                       1255    16606 D   update_data_for_tickets(integer, double precision, integer, integer)    FUNCTION     7  CREATE FUNCTION public.update_data_for_tickets(_ticket_id integer, _price double precision, _flight integer, _passanger_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE tickets 
			SET price = _price, flight = _flight, passanger_id = _passanger_id WHERE ticket_id = _ticket_id;
	END;
$$;
 �   DROP FUNCTION public.update_data_for_tickets(_ticket_id integer, _price double precision, _flight integer, _passanger_id integer);
       public          postgres    false                       1255    16608 D   update_data_for_users(integer, character varying, character varying)    FUNCTION     	  CREATE FUNCTION public.update_data_for_users(_user_id integer, _login character varying, _password character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE users 
			SET login = _login, password = _password WHERE user_id = _user_id;
	END;
$$;
 u   DROP FUNCTION public.update_data_for_users(_user_id integer, _login character varying, _password character varying);
       public          postgres    false                       1255    41716 =   updatepassword(integer, character varying, character varying)    FUNCTION     #  CREATE FUNCTION public.updatepassword(_user_id integer, _login character varying, _password character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$	
	
	DECLARE
		_row RECORD;
	
	DECLARE
		my_cursor CURSOR FOR SELECT login, password, user_id FROM users;
		
	BEGIN
-- 		OPEN my_cursor;
		
-- 		FETCH NEXT FROM my_cursor INTO _login, _password, _user_id;

		FOR _row IN my_cursor
		LOOP
			UPDATE users
				SET login = _login, password = _password WHERE user_id = _user_id;
			EXIT WHEN NOT FOUND;
		END LOOP;

-- 		CLOSE my_cursor;
	END;
$$;
 n   DROP FUNCTION public.updatepassword(_user_id integer, _login character varying, _password character varying);
       public          postgres    false            "           1255    50117 :   updateview(public.ticket_for_user, public.ticket_for_user)    FUNCTION     &  CREATE FUNCTION public.updateview(oldtable public.ticket_for_user, newtable public.ticket_for_user) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE tickets
			SET price = newTable.price, code = newTable.code, flight = newTable.flight_id, passanger_id = newTable.user_id WHERE ticket_id = oldTable.ticket_id;
		UPDATE flights
			SET departure_city = newTable.departure_city, arrival_city = newTable.arrival_city WHERE flight_id = oldTable.flight_id;
		UPDATE users
			SET login = newTable.login WHERE user_id = oldTable.user_id;
	END;
$$;
 c   DROP FUNCTION public.updateview(oldtable public.ticket_for_user, newtable public.ticket_for_user);
       public          postgres    false    225            �            1259    50067 	   airplanes    TABLE     �   CREATE TABLE public.airplanes (
    airplane_id integer NOT NULL,
    airpale_name character varying(30),
    seats integer,
    reserved_seats integer,
    port_id text
);
    DROP TABLE public.airplanes;
       public         heap    postgres    false            �           0    0    TABLE airplanes    ACL     �   GRANT SELECT ON TABLE public.airplanes TO default_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.airplanes TO administrator;
          public          postgres    false    219            �            1259    50066    airplanes_airplane_id_seq    SEQUENCE     �   CREATE SEQUENCE public.airplanes_airplane_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.airplanes_airplane_id_seq;
       public          postgres    false    219            �           0    0    airplanes_airplane_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.airplanes_airplane_id_seq OWNED BY public.airplanes.airplane_id;
          public          postgres    false    218            �           0    0 "   SEQUENCE airplanes_airplane_id_seq    ACL     �   GRANT SELECT,USAGE ON SEQUENCE public.airplanes_airplane_id_seq TO default_user;
GRANT ALL ON SEQUENCE public.airplanes_airplane_id_seq TO administrator;
          public          postgres    false    218            �            1259    50075    flights_flight_id_seq    SEQUENCE     �   CREATE SEQUENCE public.flights_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.flights_flight_id_seq;
       public          postgres    false    221            �           0    0    flights_flight_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.flights_flight_id_seq OWNED BY public.flights.flight_id;
          public          postgres    false    220            �           0    0    SEQUENCE flights_flight_id_seq    ACL     �   GRANT SELECT,USAGE ON SEQUENCE public.flights_flight_id_seq TO default_user;
GRANT ALL ON SEQUENCE public.flights_flight_id_seq TO administrator;
          public          postgres    false    220            �            1259    50109    ticket_info    VIEW     !  CREATE VIEW public.ticket_info AS
 SELECT flights.departure_city,
    flights.arrival_city,
    tickets.price,
    users.login
   FROM ((public.flights
     JOIN public.tickets ON ((flights.flight_id = tickets.flight)))
     JOIN public.users ON ((users.user_id = tickets.passanger_id)));
    DROP VIEW public.ticket_info;
       public          postgres    false    221    221    223    223    223    217    217    221            �            1259    50089    tickets_ticket_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tickets_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tickets_ticket_id_seq;
       public          postgres    false    223            �           0    0    tickets_ticket_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.tickets_ticket_id_seq OWNED BY public.tickets.ticket_id;
          public          postgres    false    222            �           0    0    SEQUENCE tickets_ticket_id_seq    ACL     �   GRANT SELECT,USAGE ON SEQUENCE public.tickets_ticket_id_seq TO default_user;
GRANT ALL ON SEQUENCE public.tickets_ticket_id_seq TO administrator;
          public          postgres    false    222            �            1259    50058    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    217            �           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    216            �           0    0    SEQUENCE users_user_id_seq    ACL     �   GRANT SELECT,USAGE ON SEQUENCE public.users_user_id_seq TO default_user;
GRANT ALL ON SEQUENCE public.users_user_id_seq TO administrator;
          public          postgres    false    216            �           2604    50070    airplanes airplane_id    DEFAULT     ~   ALTER TABLE ONLY public.airplanes ALTER COLUMN airplane_id SET DEFAULT nextval('public.airplanes_airplane_id_seq'::regclass);
 D   ALTER TABLE public.airplanes ALTER COLUMN airplane_id DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    50079    flights flight_id    DEFAULT     v   ALTER TABLE ONLY public.flights ALTER COLUMN flight_id SET DEFAULT nextval('public.flights_flight_id_seq'::regclass);
 @   ALTER TABLE public.flights ALTER COLUMN flight_id DROP DEFAULT;
       public          postgres    false    220    221    221            �           2604    50093    tickets ticket_id    DEFAULT     v   ALTER TABLE ONLY public.tickets ALTER COLUMN ticket_id SET DEFAULT nextval('public.tickets_ticket_id_seq'::regclass);
 @   ALTER TABLE public.tickets ALTER COLUMN ticket_id DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    50062    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    217    216    217            x          0    50067 	   airplanes 
   TABLE DATA           ^   COPY public.airplanes (airplane_id, airpale_name, seats, reserved_seats, port_id) FROM stdin;
    public          postgres    false    219   !�       z          0    50076    flights 
   TABLE DATA           �   COPY public.flights (flight_id, departure_date, arrival_date, departure_city, arrival_city, airplane_id, unique_string) FROM stdin;
    public          postgres    false    221   ��       |          0    50090    tickets 
   TABLE DATA           O   COPY public.tickets (ticket_id, price, code, flight, passanger_id) FROM stdin;
    public          postgres    false    223   ��       v          0    50059    users 
   TABLE DATA           9   COPY public.users (user_id, login, password) FROM stdin;
    public          postgres    false    217   �       �           0    0    airplanes_airplane_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.airplanes_airplane_id_seq', 7, true);
          public          postgres    false    218            �           0    0    flights_flight_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.flights_flight_id_seq', 7, true);
          public          postgres    false    220            �           0    0    tickets_ticket_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.tickets_ticket_id_seq', 11, true);
          public          postgres    false    222            �           0    0    users_user_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_user_id_seq', 3, true);
          public          postgres    false    216            �           2606    50074    airplanes airplanes_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.airplanes
    ADD CONSTRAINT airplanes_pkey PRIMARY KEY (airplane_id);
 B   ALTER TABLE ONLY public.airplanes DROP CONSTRAINT airplanes_pkey;
       public            postgres    false    219            �           2606    50083    flights flights_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flight_id);
 >   ALTER TABLE ONLY public.flights DROP CONSTRAINT flights_pkey;
       public            postgres    false    221            �           2606    50097    tickets tickets_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (ticket_id);
 >   ALTER TABLE ONLY public.tickets DROP CONSTRAINT tickets_pkey;
       public            postgres    false    223            �           2606    50065    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    217            �           1259    50136    airplane_name_idx    INDEX     O   CREATE INDEX airplane_name_idx ON public.airplanes USING btree (airpale_name);
 %   DROP INDEX public.airplane_name_idx;
       public            postgres    false    219            �           1259    50139    fl_idx    INDEX     ?   CREATE INDEX fl_idx ON public.flights USING btree (flight_id);
    DROP INDEX public.fl_idx;
       public            postgres    false    221            �           1259    50142    log_idx    INDEX     L   CREATE INDEX log_idx ON public.users USING gin (login public.gin_trgm_ops);
    DROP INDEX public.log_idx;
       public            postgres    false    2    2    2    2    2    2    2    2    2    2    2    2    217            �           1259    50137 	   login_idx    INDEX     C   CREATE UNIQUE INDEX login_idx ON public.users USING btree (login);
    DROP INDEX public.login_idx;
       public            postgres    false    217            �           1259    50138    port_idx    INDEX     H   CREATE UNIQUE INDEX port_idx ON public.airplanes USING btree (port_id);
    DROP INDEX public.port_idx;
       public            postgres    false    219            �           1259    50140 	   price_idx    INDEX     =   CREATE INDEX price_idx ON public.tickets USING hash (price);
    DROP INDEX public.price_idx;
       public            postgres    false    223            �           1259    50141    reserved_seats_idx    INDEX     Q   CREATE INDEX reserved_seats_idx ON public.airplanes USING hash (reserved_seats);
 &   DROP INDEX public.reserved_seats_idx;
       public            postgres    false    219            t           2618    50122 "   ticket_for_user deletedatafromview    RULE     �   CREATE RULE deletedatafromview AS
    ON DELETE TO public.ticket_for_user DO INSTEAD  SELECT public.deletedatafromview(old.*) AS deletedatafromview;
 8   DROP RULE deletedatafromview ON public.ticket_for_user;
       public          postgres    false    225    225    225    292            s           2618    50120    ticket_for_user insert_view    RULE     ~   CREATE RULE insert_view AS
    ON INSERT TO public.ticket_for_user DO INSTEAD  SELECT public.insertview(new.*) AS insertview;
 1   DROP RULE insert_view ON public.ticket_for_user;
       public          postgres    false    225    291    225    225            r           2618    50118    ticket_for_user update_view    RULE     �   CREATE RULE update_view AS
    ON UPDATE TO public.ticket_for_user DO INSTEAD  SELECT public.updateview(old.*, new.*) AS updateview;
 1   DROP RULE update_view ON public.ticket_for_user;
       public          postgres    false    225    225    225    290            �           2620    50123    tickets generate_code_trigger    TRIGGER     {   CREATE TRIGGER generate_code_trigger BEFORE INSERT ON public.tickets FOR EACH ROW EXECUTE FUNCTION public.generate_code();
 6   DROP TRIGGER generate_code_trigger ON public.tickets;
       public          postgres    false    223    273            �           2606    50084     flights flights_airplane_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_airplane_id_fkey FOREIGN KEY (airplane_id) REFERENCES public.airplanes(airplane_id);
 J   ALTER TABLE ONLY public.flights DROP CONSTRAINT flights_airplane_id_fkey;
       public          postgres    false    219    221    3285            �           2606    50098    tickets tickets_flight_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_flight_fkey FOREIGN KEY (flight) REFERENCES public.flights(flight_id);
 E   ALTER TABLE ONLY public.tickets DROP CONSTRAINT tickets_flight_fkey;
       public          postgres    false    223    221    3290            �           2606    50103 !   tickets tickets_passanger_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_passanger_id_fkey FOREIGN KEY (passanger_id) REFERENCES public.users(user_id);
 K   ALTER TABLE ONLY public.tickets DROP CONSTRAINT tickets_passanger_id_fkey;
       public          postgres    false    217    3282    223            x   ~   x�E��
�@��٧�(���ٳ<�"�(b�* �F������f��a��3|��JI(&0f\zΔ�~?�׳qq0'dGwX�����<����������ߦm�ͩ���E>"�m�/��}r �      z   �   x�U��N!Fח��h��Zv���I��XZ'm��h__�ǎ�=9߹���l�Ԝ���J�`�ӳ�k�B>�+<��n`�1���\�-����+��4ڹ� p���C���X5������{J�"���%�u옾�XM��X�P�m�g���/Ӏgf2I���t^W�����}O�+}gx	7���g�l�[k+͢���X݊�B���C>�����Z��}���KX�      |   `   x�m�;
�0E�zf1���TDmR
A4�h��,`����1t�k�ޚ�}<�ȱ��
8����� ���u��%����$!0��-G�"QR[��?_8	      v   +   x�3�����,I�4�2���ϩL�4�2��,K��4����� ��     