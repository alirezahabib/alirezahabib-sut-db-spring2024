CREATE TABLE guest
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    address    TEXT
);

CREATE TABLE room_type
(
    id          SERIAL PRIMARY KEY,
    description VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE room
(
    id            SERIAL PRIMARY KEY,
    room_type     VARCHAR(255) REFERENCES room_type (description),
    max_occupancy INTEGER NOT NULL
);

CREATE TABLE rate
(
    room_type VARCHAR(255) REFERENCES room_type (description) NOT NULL,
    occupancy INTEGER                                         NOT NULL,
    amount    DECIMAL(10, 2)                                  NOT NULL,
    PRIMARY KEY (room_type, occupancy)
);

CREATE TABLE booking
(
    booking_id          SERIAL PRIMARY KEY,
    booking_date        DATE                                            NOT NULL,
    room_no             INTEGER REFERENCES room (id),
    guest_id            INTEGER REFERENCES guest (id)                   NOT NULL,
    occupants           INTEGER                                         NOT NULL,
    room_type_requested VARCHAR(255) REFERENCES room_type (description) NOT NULL,
    nights              INTEGER                                         NOT NULL,
    arrival_time        TIME,
    CONSTRAINT fk3 FOREIGN KEY (room_type_requested, occupants) REFERENCES rate (room_type, occupancy)
);

CREATE TABLE extra
(
    extra_id    SERIAL PRIMARY KEY,
    booking_id  INTEGER REFERENCES booking (booking_id) NOT NULL,
    description TEXT                                    NOT NULL,
    amount      DECIMAL(10, 2)                          NOT NULL
);

INSERT INTO room_type (description)
VALUES ('single'),
       ('double'),
       ('family'),
       ('twin');

INSERT INTO rate (room_type, occupancy, amount)
VALUES ('double', 1, 56.00),
       ('double', 2, 72.00),
       ('family', 1, 56.00),
       ('family', 2, 72.00),
       ('family', 3, 84.00),
       ('single', 1, 48.00),
       ('twin', 1, 50.00),
       ('twin', 2, 72.00);

INSERT INTO room (id, room_type, max_occupancy)
VALUES (101, 'single', 1),
       (102, 'double', 2),
       (103, 'double', 2),
       (104, 'double', 2),
       (105, 'family', 3);

INSERT INTO guest (id, first_name, last_name, address)
VALUES (1027, 'Ali', 'Aliani', 'Ali Edinburgh'),
       (1179, 'Reza', 'Rezaei', 'Reza abad'),
       (1106, 'Lale', 'Lalei', 'Lale abad'),
       (1238, 'Pooran', 'Poorani', 'Pooran abad');

INSERT INTO booking (booking_id, booking_date, room_no, guest_id, occupants, room_type_requested, nights, arrival_time)
VALUES (5001, '2016-11-03', 101, 1027, 1, 'single', 7, '13:00'),
       (5002, '2016-11-03', 102, 1179, 1, 'double', 2, '18:00'),
       (5003, '2016-11-03', 103, 1106, 2, 'double', 2, '21:00'),
       (5004, '2016-11-03', 104, 1238, 1, 'double', 3, '22:00');

-- 1
SELECT guest.first_name, guest.last_name
FROM guest
         JOIN booking ON guest.id = booking.guest_id
WHERE booking.booking_date = '2016-11-03'
ORDER BY booking.arrival_time;

-- 2
SELECT guest_id, COUNT(booking_id) AS number_of_bookings, SUM(nights) AS total_nights
FROM booking
WHERE guest_id IN (1185, 1270)
GROUP BY guest_id;

-- 3
SELECT g.last_name, g.first_name, g.address, COALESCE(SUM(b.nights), 0) AS total_nights
FROM guest g
         LEFT JOIN booking b ON g.id = b.guest_id
WHERE g.address LIKE '%Edinburgh%'
GROUP BY g.last_name, g.first_name, g.address
ORDER BY g.last_name,
         g.first_name;

-- 4
SELECT booking_date,
       COUNT(*) AS number_of_reservations
FROM booking
WHERE booking_date >= '2016-11-25'
GROUP BY booking_date
ORDER BY booking_date;

-- 5: Number of reservations (guest entities) present
SELECT COUNT(*) AS present_guests
FROM booking
WHERE booking_date <= '2016-11-21'
  AND '2016-11-21' < (booking_date + nights);

-- 5: Number of "People" (occupants) present
SELECT COALESCE(SUM(occupants), 0) AS present_occupants
FROM booking
WHERE booking_date <= '2016-11-21'
  AND '2016-11-21' < (booking_date + nights);
