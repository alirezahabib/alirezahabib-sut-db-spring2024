CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    fullname VARCHAR(255),
    bankAccountNumber VARCHAR(31),
    nationalCode VARCHAR(31)
);

CREATE TABLE Logins (
    user_id INTEGER NOT NULL REFERENCES Users(id),
    datetime TIMESTAMP NOT NULL,
    location VARCHAR(255),
    platform VARCHAR(255),
    PRIMARY KEY (user_id, datetime)
);

CREATE TABLE Wallets (
    id SERIAL PRIMARY KEY,
    blocked_amount NUMERIC(19, 4) NOT NULL,
    currency VARCHAR(255) NOT NULL,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    last_balance_update_number INTEGER
);

CREATE TABLE BalanceUpdates (
    number SERIAL PRIMARY KEY,
    datetime TIMESTAMP NOT NULL,
    newBalance NUMERIC(19, 4) NOT NULL,
    wallet_id INTEGER NOT NULL,
    FOREIGN KEY (wallet_id) REFERENCES Wallets(id)
);

ALTER TABLE Wallets ADD FOREIGN KEY (last_balance_update_number) REFERENCES BalanceUpdates(number);

CREATE TABLE Trades (
    id SERIAL PRIMARY KEY,
    datetime TIMESTAMP NOT NULL,
    amount NUMERIC(19, 4) NOT NULL,
    wallet_id INTEGER NOT NULL REFERENCES Wallets(id)
);

CREATE TABLE Transactions (
    tracking_number SERIAL PRIMARY KEY,
    amount NUMERIC(19, 4) NOT NULL,
    type VARCHAR(15),
    trade_id INTEGER REFERENCES Trades(id)
);

CREATE TABLE ChargeBalanceUpdates (
    balance_update_number INTEGER REFERENCES BalanceUpdates(number) PRIMARY KEY,
    charge_amount NUMERIC(19, 4) NOT NULL
);

CREATE TABLE TransactionBalanceUpdates (
    balance_update_number INTEGER REFERENCES BalanceUpdates(number) PRIMARY KEY,
    transaction_tracking_number INTEGER NOT NULL REFERENCES Transactions(tracking_number)
);

CREATE TABLE Markets (
    id SERIAL PRIMARY KEY,
    working_currency VARCHAR(255) NOT NULL,
    base_currency VARCHAR(255) NOT NULL,
    fee NUMERIC(19, 4) NOT NULL
);

CREATE TABLE ArchiveOrders (
    id SERIAL PRIMARY KEY,
    creation_time TIMESTAMP NOT NULL,
    initial_number NUMERIC(19, 4) NOT NULL,
    type VARCHAR(50) NOT NULL,
    unit_price NUMERIC(19, 4) NOT NULL,
    market_id INTEGER NOT NULL REFERENCES Markets(id),
    wallet_id INTEGER NOT NULL REFERENCES Wallets(id)
);

CREATE TABLE ActiveOrders (
    archive_order_id INTEGER NOT NULL REFERENCES ArchiveOrders(id),
    remained_number NUMERIC(19, 4) NOT NULL
);

CREATE TABLE P2PTrades (
    trade_id INTEGER REFERENCES Trades(id) PRIMARY KEY,
    archive_order_id INTEGER NOT NULL REFERENCES ArchiveOrders(id)
);

CREATE TABLE OTCTrades (
    trade_id INTEGER REFERENCES Trades(id) PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    unit_price NUMERIC(19, 4) NOT NULL
);
