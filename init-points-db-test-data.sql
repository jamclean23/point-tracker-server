-- Creates a test database for point tracker

-- Create a listener for approved status changes
CREATE OR REPLACE FUNCTION notify_approval_update() RETURNS trigger AS $$
BEGIN
    PERFORM pg_notify('approval_update', NEW.id::text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER approval_update_trigger
AFTER UPDATE OF approved ON users
FOR EACH ROW
WHEN (OLD.approved IS DISTINCT FROM NEW.approved)
EXECUTE FUNCTION notify_approval_update();

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- Mock clients
CREATE TABLE clients (
    client_uid UUID NOT NULL PRIMARY KEY,
    client_name VARCHAR(150) UNIQUE
);

insert into clients (client_uid, client_name) values ('b360f733-d603-420b-b7cc-ad19ddaeb064', 'Stiedemann-Effertz');
insert into clients (client_uid, client_name) values ('a29df86f-6821-4230-805f-01d0889ce3ca', 'Kohler-Nikolaus');
insert into clients (client_uid, client_name) values ('bf25387b-f58b-4988-b79e-c3d96e9c3ded', 'Lehner-Veum');
insert into clients (client_uid, client_name) values ('9adc3314-bdb4-450e-9918-bd55afa6eb35', 'Schoen, Macejkovic and O''Conner');
insert into clients (client_uid, client_name) values ('101fc039-9dfb-4cb5-98e9-1f825c7c4cb7', 'Fadel, Wilkinson and Brakus');


-- Mock contacts
CREATE TABLE contacts (
    contact_uid UUID NOT NULL PRIMARY KEY,
    client_uid UUID NOT NULL REFERENCES clients(client_uid),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE
);

insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('2bea9744-a210-41ba-8f05-af34ef65770c', 'b360f733-d603-420b-b7cc-ad19ddaeb064', 'Horton', 'Badcock', 'hbadcock0@bloglovin.com', null);
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('400cf048-ed4e-4a49-9212-98d1414e3e3f', 'a29df86f-6821-4230-805f-01d0889ce3ca', 'Brita', 'Pinckstone', 'bpinckstone1@ameblo.jp', '221-889-3236');
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('4c282218-4cd4-4180-92c4-d26f803973b8', 'bf25387b-f58b-4988-b79e-c3d96e9c3ded', 'Viole', 'Harrill', 'vharrill2@rakuten.co.jp', '800-819-8478');
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('fb95e33b-0a72-489c-8c0a-16e18916ec76', '9adc3314-bdb4-450e-9918-bd55afa6eb35', 'Morty', 'Seer', 'mseer3@flavors.me', '496-461-9155');
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('3cb15264-aca3-4ccc-937d-366dbb16336e', '101fc039-9dfb-4cb5-98e9-1f825c7c4cb7', 'Rosemonde', 'Voaden', 'rvoaden4@addtoany.com', '331-767-0550');
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('b36bd451-0d57-4618-900f-1c803ebb5bcc', 'bf25387b-f58b-4988-b79e-c3d96e9c3ded', 'Leonelle', 'Dudleston', 'ldudleston5@elegantthemes.com', '535-548-7165');
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('2b9c3e2a-89cb-4651-8c5e-5bf1cac26731', '101fc039-9dfb-4cb5-98e9-1f825c7c4cb7', 'Daffi', 'Beevor', 'dbeevor6@sciencedaily.com', '739-969-4211');
insert into contacts (contact_uid, client_uid, first_name, last_name, email, phone) values ('0db6123e-82ba-47c1-bff5-1db90787a4f4', 'a29df86f-6821-4230-805f-01d0889ce3ca', 'Zorana', 'Symones', 'zsymones7@xing.com', '592-673-8087');


-- Mock operations
CREATE TABLE operations (
    op_uid UUID NOT NULL PRIMARY KEY,
    client_uid UUID NOT NULL REFERENCES clients(client_uid),
    op_name VARCHAR(100) NOT NULL UNIQUE,
    lat DOUBLE PRECISION NOT NULL,
    long DOUBLE PRECISION NOT NULL
);

-- Stiedemann-Effertz

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    'b360f733-d603-420b-b7cc-ad19ddaeb064', -- client id
    'Silver Hill Quarry', -- operation name
    40.18849101658891, -- latitude
    -75.97731875244419 -- longitude
);

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    'b360f733-d603-420b-b7cc-ad19ddaeb064', -- client id
    'Granite Canyon Quarry', -- operation name
    41.10543836713045, -- latitude
    -105.17453753884733 -- longitude
);

-- Kohler-Nikolaus

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    'a29df86f-6821-4230-805f-01d0889ce3ca', -- client id
    'Bison Materials', -- operation name
    36.78678973029846, -- latitude
    -95.89864998232473 -- longitude
);

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    'a29df86f-6821-4230-805f-01d0889ce3ca', -- client id
    'Dolese 7 Mile Mine', -- operation name
    36.7862999621044, -- latitude
    -96.96389459223289 -- longitude
);

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    'a29df86f-6821-4230-805f-01d0889ce3ca', -- client id
    'Greeley Quarry', -- operation name
    38.388272284315114, -- latitude
    -95.06343828956122 -- longitude
);

-- Lehner-Veum

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    'bf25387b-f58b-4988-b79e-c3d96e9c3ded', -- client id
    'Mercer County Airport', -- operation name
    47.2911490349659, -- latitude
    -101.57978307555601 -- longitude
);

-- Schoen, Macejkovic and O'Conner

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    '9adc3314-bdb4-450e-9918-bd55afa6eb35', -- client id
    'Brookhaven Landfill', -- operation name
    40.801374609060446, -- latitude
    -72.92477517573985 -- longitude
);

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    '9adc3314-bdb4-450e-9918-bd55afa6eb35', -- client id
    'Burlington County Landfill', -- operation name
    40.07662001691795, -- latitude
    -74.76302501606928 -- longitude
);

-- Fadel, Wilkinson and Brakus

insert into operations (
    op_uid, -- operation id
    client_uid, -- client id
    op_name, -- operation name
    lat, -- latitude
    long -- longitude
) values (
    gen_random_uuid(), -- operation id
    '101fc039-9dfb-4cb5-98e9-1f825c7c4cb7', -- client id
    'Keigley Quarry', -- operation name
    40.01055513484367, -- latitude
    -111.80859417026912 -- longitude
);


-- Mock control points
CREATE TABLE control_points (
    cp_uid UUID NOT NULL PRIMARY KEY,
    op_uid UUID NOT NULL REFERENCES operations(op_uid),
    cp_name VARCHAR(100) NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    long DOUBLE PRECISION NOT NULL
);

-- CLIENT: Stiedemann-Effertz

-- Silver Hill Quarry

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Silver Hill Quarry'), -- Operation uid
    'Test', -- Control point name
    40.18821235089197, -- Lat
    -75.98027991101658 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Silver Hill Quarry'), -- Operation uid
    'Test', -- Control point name
    40.18576168266497, -- Lat
    -75.98068760676205 -- Long
);

-- Granite Canyon Quarry

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Granite Canyon Quarry'), -- Operation uid
    'Test', -- Control point name
    41.10660247995042, -- Lat
    -105.16668403132927 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Granite Canyon Quarry'), -- Operation uid
    'Test', -- Control point name
    41.1075078867648, -- Lat
    -105.18788421009387 -- Long
);

-- CLIENT: Kohler-Nikolaus

-- Bison Materials

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Bison Materials'), -- Operation uid
    'Test', -- Control point name
    36.7921511984385, -- Lat
    -95.89884310136206 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Bison Materials'), -- Operation uid
    'Test', -- Control point name
    36.791154543648304, -- Lat
    -95.88940172620374 -- Long
);

-- Dolese 7 Mile Mine

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Dolese 7 Mile Mine'), -- Operation uid
    'Test', -- Control point name
    36.78757163443587, -- Lat
    -96.96537517151909 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Dolese 7 Mile Mine'), -- Operation uid
    'Test', -- Control point name
    36.78538056423371, -- Lat
    -96.96252130130077 -- Long
);

-- Greeley Quarry

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Greeley Quarry'), -- Operation uid
    'Test', -- Control point name
    38.389079590115664, -- Lat
    -95.06297694963872 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Greeley Quarry'), -- Operation uid
    'Test', -- Control point name
    38.3868174292335, -- Lat
    -95.06341683189041 -- Long
);

-- CLIENT: Lehner-Veum

-- Mercer County Airport

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Mercer County Airport'), -- Operation uid
    'Test', -- Control point name
    47.295806162202624, -- Lat
    -101.58536206996774 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Mercer County Airport'), -- Operation uid
    'Test', -- Control point name
    47.28416257511434, -- Lat
    -101.57665025561712 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Mercer County Airport'), -- Operation uid
    'Test', -- Control point name
    47.291847630197104, -- Lat
    -101.5763069328841 -- Long
);

-- CLIENT: Schoen, Macejkovic and O'Conner

-- Brookhaven Landfill

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Brookhaven Landfill'), -- Operation uid
    'Test', -- Control point name
    40.79793100055634, -- Lat
    -72.93146996903393 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Brookhaven Landfill'), -- Operation uid
    'Test', -- Control point name
    40.792992684152104, -- Lat
    -72.93657689468775 -- Long
);

-- Burlington County Landfill

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Burlington County Landfill'), -- Operation uid
    'Test', -- Control point name
    40.0750109289636, -- Lat
    -74.76012823050932 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Burlington County Landfill'), -- Operation uid
    'Test', -- Control point name
    40.078179810785144, -- Lat
    -74.76347562715637 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Burlington County Landfill'), -- Operation uid
    'Test', -- Control point name
    40.07443624548011, -- Lat
    -74.76551410588374 -- Long
);

-- CLIENT: Fadel, Wilkinson and Brakus

-- Keigley Quarry

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Keigley Quarry'), -- Operation uid
    'Test', -- Control point name
    40.01459802239099, -- Lat
    -111.80865854328157 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Keigley Quarry'), -- Operation uid
    'Test', -- Control point name
    40.00669280316754, -- Lat
    -111.81067556433811 -- Long
);

insert into control_points (
    cp_uid,
    op_uid, 
    cp_name, 
    lat, 
    long
) values (
    gen_random_uuid(), -- Control point uid
    (SELECT op_uid FROM operations WHERE op_name = 'Keigley Quarry'), -- Operation uid
    'Test', -- Control point name
    40.00879656837085, -- Lat
    -111.80370182132346 -- Long
);