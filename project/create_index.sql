CREATE INDEX idx_archiveorders_unit_price ON ArchiveOrders(unit_price);
CREATE INDEX idx_archiveorders_market_id_id ON ArchiveOrders(market_id, id);
CREATE INDEX idx_markets_working_currency ON Markets(working_currency);
CREATE INDEX idx_wallets_currency ON Wallets(currency);
