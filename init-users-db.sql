-- Create the users table with indexes
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(20) NOT NULL UNIQUE,
    password_digest VARCHAR NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(345) NOT NULL UNIQUE,
    phone VARCHAR(20),
    note TEXT,
    admin BOOLEAN DEFAULT FALSE NOT NULL,
    approved BOOLEAN DEFAULT FALSE NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create function and trigger for approval update
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

-- Ensure UUID extension is enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
