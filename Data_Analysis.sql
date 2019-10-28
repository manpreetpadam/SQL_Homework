--1.How can you isolate (or group) the transactions of each cardholder
SELECT ch."Name",cc."Card",t."Amount",t."Date",m."Name",mc."Name" FROM "Transactions" AS t
INNER JOIN "CreditCards" AS cc ON t."Card" = cc."Card"
INNER JOIN "CardHolders" AS ch ON cc."CardHolderId" = ch."Id"
INNER JOIN "Merchant" AS m ON t."Id_Merchant" = m."Id"
INNER JOIN "Merchant_Category" AS mc ON mc."Id" = m."Id_Merchant_Category"
ORDER BY ch."Name" ;

--2.Consider the time period 7:00 a.m. to 9:00 a.m.
--DROP  TABLE IF EXISTS FilteredTransactions;
CREATE TEMP TABLE IF NOT EXISTS FilteredTransactions (
	ID SERIAL PRIMARY KEY,
	Name CHARACTER VARYING(200),
	Card NUMERIC(25,0) NOT NULL,
    Amount NUMERIC(10,2) NOT NULL,
	TransactionDate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	MerchantName CHARACTER VARYING(200),
	MerchantCategoryName CHARACTER VARYING(200)
);
--TRUNCATE is only used to clear the data for testing purpose.Not advised.
--TRUNCATE TABLE FilteredTransactions RESTART IDENTITY;
INSERT INTO FilteredTransactions (Name,Card,Amount,TransactionDate,MerchantName,MerchantCategoryName)
SELECT ch."Name",cc."Card",t."Amount",t."Date",m."Name",mc."Name" FROM "Transactions" AS t
INNER JOIN "CreditCards" AS cc ON t."Card" = cc."Card"
INNER JOIN "CardHolders" AS ch ON cc."CardHolderId" = ch."Id"
INNER JOIN "Merchant" AS m ON t."Id_Merchant" = m."Id"
INNER JOIN "Merchant_Category" AS mc ON mc."Id" = m."Id_Merchant_Category"
WHERE DATE_PART('HOUR',t."Date")>=7 AND DATE_PART('HOUR',t."Date")<9
ORDER BY ch."Name" ;

--What are the top 100 highest transactions during this time period?
SELECT DISTINCT * FROM filteredtransactions
ORDER BY AMOUNT DESC
LIMIT 100;

--Do you see any fraudulent or anomalous transactions?
--Yes

--If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.
--There are 9 huge transactions at bar,coffee shop,restaurant early in the morning between 7AM and 9AM which is odd.

--Some fraudsters hack a credit card by making several small payments (generally less than $2.00), 
--which are typically 
--ignored by cardholders. Count the transactions that are less than $2.00 per cardholder. 

SELECT ch."Name", Count(t."Id") AS "Total_Small_Transactions",t."Card" FROM "Transactions" AS t
INNER JOIN "CreditCards" AS cc ON t."Card" = cc."Card"
INNER JOIN "CardHolders" AS ch ON cc."CardHolderId" = ch."Id"
WHERE t."Amount"<2
GROUP BY t."Card",ch."Name"
ORDER BY "Total_Small_Transactions" DESC;

--Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
--Even though multiple transactions with less than $2.00 were detected it doesn't indicate strong evidence 
--that the credit card was hacked.

--What are the top 5 merchants prone to being hacked using small transactions?
SELECT m."Name" AS "Merchant",mc."Name" AS "Merchant Category",Count(t."Id") AS "Total_Small_Trans" FROM "Transactions" AS t
INNER JOIN "Merchant" AS m ON m."Id" = t."Id_Merchant"
INNER JOIN "Merchant_Category" mc ON mc."Id" = m."Id_Merchant_Category"
WHERE t."Amount"<2
GROUP BY m."Name",mc."Name"
ORDER BY "Total_Small_Trans" DESC
LIMIT 5;

--Once you have a query that can be reused, create a view for each of the previous queries.
CREATE VIEW TransactionDetails AS
SELECT t."Id",t."Date",t."Amount",m."Name" AS "MerchantName",
		mc."Name" AS "MerchantCategory",cc."Card",ch."Name" AS "CardHolderName"
FROM "Transactions" t
INNER JOIN "CreditCards" cc ON t."Card" = cc."Card"
INNER JOIN "CardHolders" ch ON ch."Id" = cc."CardHolderId"
INNER JOIN "Merchant" m ON m."Id" = t."Id_Merchant"
INNER JOIN "Merchant_Category" mc ON mc."Id" = m."Id_Merchant_Category";

SELECT * FROM transactiondetails ORDER BY "Id";