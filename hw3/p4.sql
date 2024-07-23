-- Create the tables
CREATE TABLE Books
(
    BookID SERIAL PRIMARY KEY,
    Title  TEXT           NOT NULL,
    Author TEXT           NOT NULL,
    Price  DECIMAL(10, 2) NOT NULL,
    Genre  TEXT           NOT NULL
);

CREATE TABLE Customers
(
    CustomerID SERIAL PRIMARY KEY,
    Name       TEXT NOT NULL,
    Email      TEXT NOT NULL,
    JoinDate   DATE NOT NULL
);

CREATE TABLE Orders
(
    OrderID    SERIAL PRIMARY KEY,
    CustomerID INTEGER NOT NULL,
    BookID     INTEGER NOT NULL,
    Quantity   INTEGER NOT NULL,
    OrderDate  DATE    NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    FOREIGN KEY (BookID) REFERENCES Books (BookID)
);

CREATE TABLE Reviews
(
    ReviewID   SERIAL PRIMARY KEY,
    BookID     INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    Rating     INTEGER NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    FOREIGN KEY (BookID) REFERENCES Books (BookID)
);

-- Import the data from the .csv files (adjust paths as needed)
COPY Books FROM '/Users/alireza/PycharmProjects/db-hw3/p4/tables/books.csv' DELIMITER ',';
COPY Customers FROM '/Users/alireza/PycharmProjects/db-hw3/p4/tables/customers.csv' DELIMITER ',';
COPY Orders FROM '/Users/alireza/PycharmProjects/db-hw3/p4/tables/orders.csv' DELIMITER ',';
COPY Reviews FROM '/Users/alireza/PycharmProjects/db-hw3/p4/tables/reviews.csv' DELIMITER ',';

-- 1
SELECT b.Title, SUM(o.Quantity) AS TotalSold
FROM Books b
         JOIN Orders o ON b.BookID = o.BookID
GROUP BY b.BookID
ORDER BY TotalSold DESC
LIMIT 3;

-- 2
SELECT c.Name, SUM(b.Price * o.Quantity) AS TotalSpent
FROM Customers c
         JOIN Orders o on c.CustomerID = o.CustomerID
         JOIN Books B on o.BookID = B.BookID
GROUP BY c.customerid
ORDER BY TotalSpent DESC
LIMIT 1;

-- 3: The correct version which considers the quantity of books sold
SELECT b.Genre,
       SUM(o.Quantity)                             AS TotalSold,
       SUM(b.Price * o.Quantity) / SUM(o.Quantity) AS AveragePrice
FROM Books b
         JOIN Orders o ON b.BookID = o.BookID
WHERE o.OrderDate >= '2023-01-01'
GROUP BY b.Genre;

-- 3: Your answer's version which does not consider the quantity of books sold
SELECT b.Genre,
       SUM(o.Quantity) AS TotalSold,
       AVG(b.Price)    AS AveragePrice
FROM Books b
         JOIN Orders o ON b.BookID = o.BookID
WHERE o.OrderDate >= '2023-01-01'
GROUP BY b.Genre;

-- 4: Calculate the average rating for each book and rank the books within each genre based on this average rating.
SELECT b.Title,
       b.Genre,
       COALESCE(AVG(r.Rating), 0)                                                  AS AvgRating,
       RANK() OVER (PARTITION BY b.Genre ORDER BY COALESCE(AVG(r.Rating), 0) DESC) AS GenreRank
FROM Books b
         LEFT JOIN Reviews r ON b.BookID = r.BookID
GROUP BY b.Title, b.Genre
ORDER BY b.Genre, GenreRank;
