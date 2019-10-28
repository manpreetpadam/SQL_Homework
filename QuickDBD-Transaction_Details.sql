-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/OtanaQ
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "CardHolders" (
    "Id"  SERIAL  NOT NULL,
    "Name" VARCHAR(200)   NOT NULL,
    CONSTRAINT "pk_CardHolders" PRIMARY KEY (
        "Id"
     )
);

CREATE TABLE "CreditCards" (
    "Id"  SERIAL  NOT NULL,
    "Card" NUMERIC(25,0)   NOT NULL,
    "CardHolderId" INT   NOT NULL,
    CONSTRAINT "pk_CreditCards" PRIMARY KEY (
        "Id"
     )
);

CREATE TABLE "Merchant_Category" (
    "Id"  SERIAL  NOT NULL,
    "Name" VARCHAR(200)   NOT NULL,
    CONSTRAINT "pk_Merchant_Category" PRIMARY KEY (
        "Id"
     )
);

CREATE TABLE "Merchant" (
    "Id"  SERIAL  NOT NULL,
    "Name" VARCHAR(200)   NOT NULL,
    "Id_Merchant_Category" INT   NOT NULL,
    CONSTRAINT "pk_Merchant" PRIMARY KEY (
        "Id"
     )
);

CREATE TABLE "Transactions" (
    "Id"  SERIAL  NOT NULL,
    "Date" DATETIME   NOT NULL,
    "Amount" DECIMAL(10,2)   NOT NULL,
    "Card" NUMERIC(25,0)   NOT NULL,
    "Id_Merchant" INT   NOT NULL,
    CONSTRAINT "pk_Transactions" PRIMARY KEY (
        "Id"
     )
);

ALTER TABLE "CreditCards" ADD CONSTRAINT "fk_CreditCards_CardHolderId" FOREIGN KEY("CardHolderId")
REFERENCES "CardHolders" ("Id");

ALTER TABLE "Merchant" ADD CONSTRAINT "fk_Merchant_Id_Merchant_Category" FOREIGN KEY("Id_Merchant_Category")
REFERENCES "Merchant_Category" ("Id");

ALTER TABLE "Transactions" ADD CONSTRAINT "fk_Transactions_Id_Merchant" FOREIGN KEY("Id_Merchant")
REFERENCES "Merchant" ("Id");

