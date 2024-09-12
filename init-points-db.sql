-- Creates a database for point tracker

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

-- Clients
CREATE TABLE clients (
    client_uid UUID NOT NULL PRIMARY KEY,
    client_name VARCHAR(150) UNIQUE
);


-- Contacts
CREATE TABLE contacts (
    contact_uid UUID NOT NULL PRIMARY KEY,
    client_uid UUID NOT NULL REFERENCES clients(client_uid),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE
);


-- Operations
CREATE TABLE operations (
    op_uid UUID NOT NULL PRIMARY KEY,
    client_uid UUID NOT NULL REFERENCES clients(client_uid),
    op_name VARCHAR(100) NOT NULL UNIQUE,
    lat DOUBLE PRECISION NOT NULL,
    long DOUBLE PRECISION NOT NULL
);


-- Control points
CREATE TABLE control_points (
    cp_uid UUID NOT NULL PRIMARY KEY,
    op_uid UUID NOT NULL REFERENCES operations(op_uid),
    cp_name VARCHAR(100) NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    long DOUBLE PRECISION NOT NULL
);