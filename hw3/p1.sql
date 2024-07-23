CREATE TABLE Borrowerinfo
(
    Borrower_name    VARCHAR(100) PRIMARY KEY,
    Borrower_address VARCHAR(255),
    Borrower_country VARCHAR(100)
);

CREATE TABLE Organization
(
    Organization_name    VARCHAR(100) PRIMARY KEY,
    Organization_country VARCHAR(100)
);

CREATE TABLE Loan
(
    Borrower_name     VARCHAR(100),
    Organization_name VARCHAR(100),
    Loan_amount       NUMERIC,
    PRIMARY KEY (Borrower_name, Organization_name),
    FOREIGN KEY (Borrower_name) REFERENCES Borrowerinfo (Borrower_name),
    FOREIGN KEY (Organization_name) REFERENCES Organization (Organization_name)
);

CREATE TABLE Lend
(
    Borrower_name VARCHAR(100),
    Lender_name   VARCHAR(100),
    PRIMARY KEY (Borrower_name, Lender_name),
    FOREIGN KEY (Borrower_name) REFERENCES Borrowerinfo (Borrower_name)
);

-- Import data
-- COPY Borrowerinfo FROM '/Users/alireza/PycharmProjects/db-hw3/p1/tables/borrowerinfo.csv' DELIMITER ',' CSV HEADER;
-- COPY Lend FROM '/Users/alireza/PycharmProjects/db-hw3/p1/tables/lend.csv' DELIMITER ',' CSV HEADER;
-- COPY Organization FROM '/Users/alireza/PycharmProjects/db-hw3/p1/tables/organization.csv' DELIMITER ',' CSV HEADER;
-- COPY Loan FROM '/Users/alireza/PycharmProjects/db-hw3/p1/tables/loan.csv' DELIMITER ',' CSV HEADER;

-- 1: The names of all individuals who have taken loans from organizations within the same country they reside in.
SELECT Borrowerinfo.Borrower_name
FROM Borrowerinfo
         JOIN Loan ON Borrowerinfo.Borrower_name = Loan.Borrower_name
         JOIN Organization ON Loan.Organization_name = Organization.Organization_name
WHERE Borrowerinfo.Borrower_country = Organization.Organization_country;

-- 2: The names of individuals who have taken loans from organizations in Italy and Spain, and the amount of their loans exceeds the average loan amount among all loan recipients in those two countries should be displayed in descending order based on the loan amount.
SELECT Borrowerinfo.Borrower_name, Loan.Loan_amount
FROM Borrowerinfo
         JOIN Loan ON Borrowerinfo.Borrower_name = Loan.Borrower_name
         JOIN Organization ON Loan.Organization_name = Organization.Organization_name
WHERE Organization.Organization_country IN ('Italy', 'Spain')
  AND Loan.Loan_amount > (SELECT AVG(Loan_amount)
                          FROM Loan
                                   JOIN Organization ON Loan.Organization_name = Organization.Organization_name
                          WHERE Organization.Organization_country IN ('Italy', 'Spain'))
ORDER BY Loan.Loan_amount DESC;

-- 3: The names, addresses, and countries of residence of all loan recipients who have borrowed from the organization "Quickloan" and whose loan amount exceeds 100,000.
SELECT Borrowerinfo.Borrower_name, Borrowerinfo.Borrower_address, Borrowerinfo.Borrower_country
FROM Borrowerinfo
         JOIN Loan ON Borrowerinfo.Borrower_name = Loan.Borrower_name
         JOIN Organization ON Loan.Organization_name = Organization.Organization_name
WHERE Organization.Organization_name = 'Quickloan'
  AND Loan.Loan_amount > 100000;

-- 4: Assuming that an organization can be present in multiple countries, the names of all organizations that have branches in countries where the organization "Quickloan" also has branches.
SELECT DISTINCT Organization.Organization_name
FROM Organization
WHERE Organization.Organization_country IN (SELECT Organization_country
                                            FROM Organization
                                            WHERE Organization_name = 'Quickloan');

-- 5: The names of borrowers from Borrowerinfo who do not have any loans in the Loan table.
SELECT Borrower_name
FROM Borrowerinfo
WHERE Borrower_name NOT IN (SELECT Borrower_name
                            FROM Loan);

--6: The names and countries of all borrowers from the Borrowerinfo table who have borrowed from an organization in a country different from their country of residence and the lender's name is "John".
SELECT Borrowerinfo.Borrower_name, Borrowerinfo.Borrower_country
FROM Borrowerinfo
         JOIN Lend ON Borrowerinfo.Borrower_name = Lend.Borrower_name
         JOIN Loan ON Borrowerinfo.Borrower_name = Loan.Borrower_name
         JOIN Organization ON Loan.Organization_name = Organization.Organization_name
WHERE Borrowerinfo.Borrower_country != Organization.Organization_country
  AND Lend.Lender_name = 'John';
