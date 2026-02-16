DROP view UpcomingReservations CASCADE;
DROP view StaffEventAssignments CASCADE;
DROP view TableStatus CASCADE;
DROP TABLE IF EXISTS StaffRole;
DROP TABLE IF EXISTS RestaurantTable;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer
(
  customer_id INTEGER,
  name        TEXT NOT NULL,
  phone       TEXT NOT NULL,
  email       TEXT,
  CONSTRAINT customer_idPK PRIMARY KEY (customer_id)
);

CREATE TABLE Reservation 
(
  reservation_id             INTEGER,
  reservation_datetime       TIMESTAMP NOT NULL,
  arriving_datetime          TIMESTAMP NOT NULL,
  guests                     INTEGER NOT NULL,
  status                     TEXT NOT NULL,
  customer_id                INTEGER NOT NULL,
  
  CONSTRAINT Reservation_idPK PRIMARY KEY (reservation_id),
  CONSTRAINT ReservationFK_customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE RESTRICT,
  CONSTRAINT chk_Reservation_guests_gt0 CHECK (guests > 0),
  CONSTRAINT chk_Reservation_status_pos CHECK (status IN (
    'Requested', 
    'Booked', 
    'Seated', 
    'NoShow', 
    'Cancelled'
  ))
);

CREATE TABLE Event
(
  event_id INTEGER,
  name     TEXT NOT NULL,
  kind     TEXT NOT NULL,
  reservation_id   INTEGER NOT NULL UNIQUE,
  CONSTRAINT Event_idPK PRIMARY KEY (event_id),
  CONSTRAINT EventFK_reservation FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
);

CREATE TABLE Staff
(
  staff_id INTEGER,
  name     TEXT NOT NULL,
  phone    TEXT NOT NULL,
  email    TEXT NOT NULL,
  role     TEXT,
  CONSTRAINT Staff_idPK PRIMARY KEY (staff_id)
);

CREATE TABLE StaffRole
(
  staff_id INTEGER NOT NULL,
  event_id INTEGER NOT NULL,
  role     TEXT NOT NULL,
  CONSTRAINT StaffRolePK PRIMARY KEY (staff_id, event_id),
  CONSTRAINT StaffRoleFK_staff FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
  CONSTRAINT StaffRoleFK_event FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE CASCADE,
  CONSTRAINT chk_staffrole_role_enum CHECK (role IN (
    'Runner',
    'Waiter',
    'Bartender',
    'Manager'
  ))
);

CREATE TABLE RestaurantTable
(
  table_id INTEGER,
  status   BOOLEAN NOT NULL DEFAULT TRUE,  --TRUE = available
  reservation_id   INTEGER,
  CONSTRAINT RestaurantTable_idPK PRIMARY KEY (table_id),
  CONSTRAINT Reservation_idFK FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
  CONSTRAINT chk_restauranttable_resid_pos CHECK (reservation_id IS NULL OR reservation_id > 0) 
);

CREATE VIEW UpcomingReservations AS
SELECT r.reservation_id, c.name AS customer_name, 
       r.arriving_datetime, r.guests, r.status
FROM Reservation r
JOIN Customer c ON r.customer_id = c.customer_id
WHERE r.status = 'Booked'
ORDER BY r.arriving_datetime;

CREATE VIEW StaffEventAssignments AS
SELECT e.name AS event_name, s.name AS staff_name, sr.role
FROM Staff s
JOIN StaffRole sr ON s.staff_id = sr.staff_id
JOIN Event e ON e.event_id = sr.event_id
ORDER BY e.name, s.name;

CREATE VIEW TableStatus AS
SELECT t.table_id, t.status, r.reservation_id, r.status AS reservation_status
FROM RestaurantTable t
LEFT JOIN Reservation r ON t.reservation_id = r.reservation_id;

INSERT INTO Customer VALUES (201, 'Alexis Jacques','0414 345 678', 'alexis.Jacques@example.com');
INSERT INTO Customer VALUES (202, 'Tommy Nguyen',  '0414 987 654', 'tommy.nguyen@example.com');
INSERT INTO Customer VALUES (203, 'Ava Johnson',   '0414 223 334', 'ava.johnson@example.com');
INSERT INTO Customer VALUES (204, 'Mathilde Paris','0414 778 889', 'mathilde.paris@example.com');
INSERT INTO Customer VALUES (205, 'Maxime Guenot', '0414 376 873', 'maxime.guenot@example.com');

INSERT INTO RestaurantTable (table_id, status) VALUES
  (1, TRUE),
  (2, TRUE),
  (3, TRUE),
  (4, TRUE),
  (5, FALSE),
  (6, TRUE);

INSERT INTO Reservation (reservation_id, reservation_datetime, arriving_datetime, guests, status, customer_id) VALUES 
  (1002, '2025-10-05 20:00:00','2025-10-06 19:00:00', 12, 'Requested', 202),
  (1003, '2025-10-07 18:30:00','2025-11-27 18:30:00', 8,  'Booked',    203), 
  (1001, '2025-10-08 17:00:00','2025-10-06 19:00:00', 2,  'Cancelled', 201),
  (1005, '2025-10-06 12:30:00','2025-10-11 12:00:00', 30, 'Booked',    204),
  (1006, '2025-10-02 19:00:00','2025-11-27 17:30:00', 40, 'Booked',    201);

INSERT INTO Event (event_id, name, kind, reservation_id) VALUES
  (5001, '20th Birthday',                 'Birthday',          1003),
  (5002, 'Paris Family Wedding',          'Wedding',           1005),
  (5003, 'Amazon end of semester event',  'Company Function',  1006);

INSERT INTO Staff (staff_id, name, phone, email, role) VALUES
  (301, 'Simon',     '0414 739 306', 'simon@adria.example',     'Runner'),
  (302, 'Noelie',    '0414 678 789', 'noelie@adria.example',    'Waiter'),
  (303, 'Garoo',     '0414 356 152', 'garoo@adria.example',     'Bartender'),
  (304, 'Edlyn',     '0414 873 971', 'edlyn@adria.example',     'Manager'),
  (305, 'Felipe',    '0414 255 827', 'felipe@adria.example',    'Runner'),
  (306, 'Valentina', '0414 137 383', 'valentina@adria.example', 'Runner'),
  (307, 'Thomas',    '0414 345 479', 'thomas@adria.example',    'Runner'),
  (308, 'Rebecca',   '0414 623 276', 'rebecca@adria.example',   'Bartender'),
  (309, 'Jitesh',    '0414 900 034', 'jitesh@adria.example',    'Manager'),
  (310, 'Elisa',     '0414 263 893', 'elisa@adria.example',     'Waiter'),
  (311, 'Alonso',    '0414 363 940', 'alonso@adria.example',    'Runner');

INSERT INTO StaffRole (staff_id, event_id, role) VALUES
  (301, 5001, 'Runner'),
  (305, 5001, 'Runner'),
  (302, 5001, 'Waiter'),
  (309, 5001, 'Manager'),
  (307, 5002, 'Runner'),
  (306, 5002, 'Runner'),
  (305, 5002, 'Runner'),
  (302, 5002, 'Waiter'),
  (304, 5002, 'Manager'),
  (307, 5003, 'Runner'),
  (306, 5003, 'Runner'),
  (311, 5003, 'Runner'),
  (310, 5003, 'Waiter'),
  (309, 5003, 'Manager');

INSERT INTO RestaurantTable (table_id, status, reservation_id) VALUES
  (10,  TRUE, 1001),
  (24,  TRUE, 1002),
  (13,  TRUE, 1003),
  (50,  FALSE,1005),
  (55,  TRUE, 1005),
  (500, TRUE, 1006),
  (501, FALSE,1006),
  (502, FALSE,1006),
  (503, TRUE, 1006),
  (504, TRUE, 1006),
  (505, FALSE,1006),
  (506, TRUE, 1006);
 
 
 
 
