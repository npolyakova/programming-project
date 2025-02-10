CREATE TABLE public.users (
	id serial PRIMARY KEY,
	login varchar NOT NULL,
	"password" varchar NOT NULL
);

CREATE TABLE public.rooms (
	id serial PRIMARY KEY,
	floor int4 NULL,
	"name" varchar(50) NULL,
	parent varchar(50) NULL,
	map_points varchar(128) NULL,
	id_route_point int4 NULL,
	short_name varchar NULL
);

CREATE TABLE public.route_points (
	id serial PRIMARY KEY,
	points varchar(50) NULL,
	rooms bool NULL,
	connected_points varchar(255) NULL
);

INSERT INTO public.users
(id, login, "password")
VALUES(DEFAULT, 'test', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3');