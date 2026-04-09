
-- ===================== USER FUNCTIONS =====================
CREATE OR REPLACE FUNCTION CreateUser(
    userEmail VARCHAR(300),
    userName VARCHAR(100),
    userSurname VARCHAR(100),
    userPassword VARCHAR(300),
    userIsAdmin BOOLEAN DEFAULT FALSE
)
RETURNS TABLE(
    id INTEGER,
    email VARCHAR(300),
    name VARCHAR(100),
    surname VARCHAR(100),
    isAdmin BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO users (email, name, surname, password, isAdmin)
    VALUES (userEmail, userName, userSurname, userPassword, userIsAdmin)
    RETURNING users.id, users.email, users.name, users.surname, users.isAdmin;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetAllUsers()
RETURNS TABLE(
    id INTEGER,
    email VARCHAR(300),
    name VARCHAR(100),
    surname VARCHAR(100),
    isAdmin BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.email, u.name, u.surname, u.isAdmin
    FROM users u
    ORDER BY u.id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetUserByEmail(
    userEmail VARCHAR(300)
)
RETURNS TABLE(
    id INTEGER,
    email VARCHAR(300),
    name VARCHAR(100),
    surname VARCHAR(100),
    isAdmin BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.email, u.name, u.surname, u.isAdmin
    FROM users u WHERE u.email = userEmail;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetUserByNameAndSurname(
    userName VARCHAR(100),
    userSurname VARCHAR(100)
)
RETURNS TABLE(
    id INTEGER,
    email VARCHAR(300),
    name VARCHAR(100),
    surname VARCHAR(100),
    isAdmin BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.email, u.name, u.surname, u.isAdmin
    FROM users u WHERE u.name = userName AND u.surname = userSurname;
END;
$$ LANGUAGE plpgsql;

-- ===================== CARS FUNCTIONS =====================
CREATE OR REPLACE FUNCTION CreateCar(
    carCarClass INTEGER,
    carPrice INTEGER,
    carCapacity INTEGER,
    carName VARCHAR(200)
)
RETURNS SETOF cars AS $$
BEGIN
    RETURN QUERY
    INSERT INTO cars (carClass, price, capacity, name)
    VALUES (carCarClass, carPrice, carCapacity, carName)
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetAllCars()
RETURNS SETOF cars AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM cars ORDER BY id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetCarByClass(
    carCarClass INTEGER
)
RETURNS SETOF cars AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM cars WHERE carClass = carCarClass ORDER BY id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetAvailableCars(
    carStartDate TIMESTAMP,
    carEndDate TIMESTAMP
)
RETURNS SETOF cars AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM cars 
    WHERE id NOT IN (
        SELECT carId FROM rents
        WHERE status = 'Active'
        AND dateStart < carEndDate 
        AND dateEnd > carStartDate
    )
    ORDER BY id;
END;
$$ LANGUAGE plpgsql;

-- ===================== RENTS FUNCTIONS =====================
CREATE OR REPLACE FUNCTION CreateRent(
    rentCarId INTEGER,
    rentUserId INTEGER,
    rentDateStart TIMESTAMP,
    rentDateEnd TIMESTAMP,
    rentStatus VARCHAR(100)
)
RETURNS SETOF rents AS $$
BEGIN
    RETURN QUERY
    INSERT INTO rents (carId, userId, dateStart, dateEnd, status)
    VALUES (rentCarId, rentUserId, rentDateStart, rentDateEnd, rentStatus)
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetRentActiveByUserId(
    rentUserId INTEGER
)
RETURNS SETOF rents AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM rents 
    WHERE userId = rentUserId AND status = 'Active'
    ORDER BY dateStart ASC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetRentHistoryByUserId(
    rentUserId INTEGER
)
RETURNS SETOF rents AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM rents 
    WHERE userId = rentUserId
    ORDER BY dateStart ASC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION UpdateRentStatusToInactive(
    rentId INTEGER
)
RETURNS SETOF rents AS $$
BEGIN
    RETURN QUERY
    UPDATE rents 
    SET status = 'Inactive'
    WHERE id = rentId AND status = 'Active'
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
