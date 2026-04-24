DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS cars CASCADE;
DROP TABLE IF EXISTS rents CASCADE;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(300) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    password VARCHAR(300) NOT NULL,
    isAdmin BOOLEAN DEFAULT FALSE NOT NULL
);
-- Used to find user based on his login (email)
CREATE INDEX idxUsersEmail ON users(email);
-- Used to find users that match given 'name' and 'surname' 
CREATE INDEX idxUsersNameSurname ON users 
USING GIN (name gin_trgm_ops, surname gin_trgm_ops);

CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    carClass INTEGER NOT NULL,
    price INTEGER NOT NULL CHECK (price > 0),
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    name VARCHAR(200) NOT NULL
);
-- Used to find cars based on their class
CREATE INDEX idxCarsCarClass ON cars(carClass);

CREATE TABLE rents (
    id SERIAL PRIMARY KEY,
    carId INTEGER NOT NULL REFERENCES cars(id) ON DELETE RESTRICT,
    userId INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    dateStart TIMESTAMP NOT NULL,
    dateEnd TIMESTAMP NOT NULL,
    status VARCHAR(100) NOT NULL DEFAULT 'Active',

    CONSTRAINT ValidDates CHECK (dateEnd > dateStart)
);
-- Used to find given user's id rent history
CREATE INDEX idxRentsUserId ON rents(userId);
-- Used to find all rents that match given 'userId' and status', such as 'Active' or 'Inactive'
CREATE INDEX idxRentsStatus ON rents(userId, status);
-- Used to find all rents in given range of dates 'dateStart' and 'dateEnd'
CREATE INDEX idxRentsDates ON rents(dateStart, dateEnd);
-- Used to optimize return sort in GetRentHistory/GetRentActive funcs
CREATE INDEX idxRentsUserIdDateStart ON rents(userId, dateStart);
