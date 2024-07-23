INSERT INTO Users (username, password, email, fullname, bankAccountNumber, nationalCode) VALUES
    ('user1', 'pass1', 'user1@example.com', 'User One', '1234567890', '0011223344'),
    ('user2', 'pass2', 'user2@example.com', 'User Two', '0987654321', '5544332211'),
    ('user3', 'pass3', 'user3@example.com', 'User Three', '1122334455', '6677889900');


INSERT INTO Logins (user_id, datetime, location, platform) VALUES
    (1, '2023-10-01 10:30:00', 'Location1', 'Platform1'),
    (2, '2023-10-02 11:00:00', 'Location2', 'Platform2'),
    (3, '2023-10-03 12:00:00', 'Location3', 'Platform1'),
    (1, '2023-10-04 13:00:00', 'Location1', 'Platform2'),
    (2, '2023-10-05 14:00:00', 'Location2', 'Platform1');


INSERT INTO Wallets (blocked_amount, currency, user_id, last_balance_update_number) VALUES
    (0.0, 'BTC', 1, NULL),
    (0.0, 'ETH', 2, NULL),
    (0.0, 'USDT', 3, NULL),
    (0.0, 'BTC', 2, NULL),
    (0.0, 'ETH', 1, NULL);



INSERT INTO BalanceUpdates (datetime, newBalance, wallet_id) VALUES
    ('2023-10-01 10:35:00', 1.2345, 1),
    ('2023-10-02 11:05:00', 0.5678, 2),
    ('2023-10-03 12:05:00', 100.00, 3),
    ('2023-10-01 10:45:00', 0.8900, 4),
    ('2023-10-02 11:15:00', 2.3456, 5),
    ('2023-10-04 13:15:00', 1.1111, 1),
    ('2023-10-05 14:15:00', 3.3333, 2);


INSERT INTO Trades (datetime, amount, wallet_id) VALUES
    ('2023-10-01 10:40:00', 0.1234, 1),
    ('2023-10-02 11:10:00', 0.4567, 2),
    ('2023-10-03 12:10:00', 50.00, 3),
    ('2023-10-01 10:50:00', 0.7890, 4),
    ('2023-10-02 11:20:00', 1.2345, 5);


INSERT INTO Transactions (amount, type, trade_id) VALUES
    (0.1234, 'Buy', 1),
    (0.4567, 'Sell', 2),
    (50.00, 'Buy', 3),
    (0.7890, 'Sell', 4),
    (1.2345, 'Buy', 5);


INSERT INTO ChargeBalanceUpdates (balance_update_number, charge_amount) VALUES
    (1, 1.2345),
    (2, 0.5678),
    (3, 100.00),
    (4, 0.8900),
    (5, 2.3456);


INSERT INTO TransactionBalanceUpdates (balance_update_number, transaction_tracking_number) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);


INSERT INTO Markets (working_currency, base_currency, fee) VALUES
    ('BTC', 'IRR', 0.001),
    ('ETH', 'IRR', 0.002),
    ('XRP', 'IRR', 0.003),
    ('BTC', 'IRR', 0.004),
    ('LTC', 'IRR', 0.005);


INSERT INTO ArchiveOrders (creation_time, initial_number, type, unit_price, market_id, wallet_id) VALUES
    ('2023-10-01 10:45:00', 0.5, 'Buy', 30000.00, 1, 1),
    ('2023-10-02 11:20:00', 1.0, 'Sell', 2000.00, 2, 2),
    ('2023-10-03 12:15:00', 100.0, 'Buy', 1.00, 3, 3),
    ('2023-10-04 13:05:00', 2.0, 'Sell', 0.05, 4, 4),
    ('2023-10-05 14:00:00', 3.0, 'Buy', 100.00, 2, 5);


INSERT INTO ActiveOrders (archive_order_id, remained_number) VALUES
    (1, 0.2),
    (2, 0.5),
    (3, 50.0),
    (4, 1.0),
    (5, 1.5);


INSERT INTO P2PTrades (trade_id, archive_order_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);


INSERT INTO OTCTrades (trade_id, type, unit_price) VALUES
    (1, 'Sell', 30500.00),
    (2, 'Buy', 1950.00),
    (3, 'Sell', 1.05),
    (4, 'Buy', 0.045),
    (5, 'Sell', 110.00);

UPDATE Wallets
SET last_balance_update_number = (SELECT MAX(number) FROM BalanceUpdates WHERE wallet_id = Wallets.id);
