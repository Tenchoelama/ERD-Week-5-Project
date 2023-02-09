CREATE TABLE "Salesperson" (
  "sales_person_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Mechanic" (
  "mechanic_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Customer" (
  "customer_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Invoice" (
  "invoice_id" SERIAL PRIMARY KEY,
  "car_cost" NUMERIC(10,2),
  "service_cost" NUMERIC(10,2),
  "payment_type" VARCHAR(100),
  "VIN_no" VARCHAR(100),
  "customer_id" INTEGER,
  "car_id" INTEGER,
  "sales_person_id" INTEGER,
	FOREIGN KEY("customer_id") REFERENCES "Customer",
	FOREIGN KEY ("car_id") REFERENCES "Cars",
	FOREIGN KEY ("sales_person_id") REFERENCES "Salesperson"
);

CREATE TABLE "Cars" (
  "car_id" SERIAL PRIMARY KEY,
  "make" VARCHAR(100),
  "model" VARCHAR(100),
  "year" INTEGER,
  "price" NUMERIC (10,2),
  "color" VARCHAR(100),
  "is_new" BOOLEAN,
  "VIN_no" VARCHAR(100)
);

CREATE TABLE "Service" (
  "service_id" SERIAL PRIMARY KEY,
  "service_cost" NUMERIC(10,2),
  "service_type" VARCHAR(100),
  "VIN_no" VARCHAR(100),
  "mechanic_id" INTEGER,
  "invoice_id" INTEGER,
	FOREIGN KEY ("mechanic_id") REFERENCES "Mechanic",
	FOREIGN KEY ("invoice_id") REFERENCES "Invoice"
);

SELECT *
FROM "Invoice"


/*Insert begins*/


INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Frodo',
	'Baggins'
);

INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Sam',
	'Wise'
);

INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Merry',
	'Larry'
);

INSERT INTO "Customer" (
	first_name,
	last_name
) VALUES (
	'Perigrin ',
	'Took'
);

SELECT *
FROM "Customer"

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Toyota',
	'Prius',
	'2020',
	'32000.00',
	'Blue',
	False,
	'1000'
);

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Subaru',
	'Outback',
	'2012',
	'1200.00',
	'Red',
	False,
	'1001'
);

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Tesla',
	'Model Y',
	'2021',
	'31000.00',
	'Silver',
	True,
	'1002'
);

INSERT INTO "Cars" (
	make,
	model,
	"year",
	price,
	color,
	is_new,
	"VIN_no"
) VALUES (
	'Nissan',
	'Altima',
	'1999',
	'2100.00',
	'White',
	False,
	'1003'
);

SELECT *
FROM "Cars"
WHERE "price" > '10000';

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Gandalf',
	'Gray'
);

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Saruman',
	'White'
);

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Lord',
	'Elron'
);

INSERT INTO "Salesperson" (
	first_name,
	last_name
) VALUES (
	'Lady',
	'Galadriel'
);

SELECT *
FROM "Salesperson"

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Argaon',
	'Ranger'
);

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Legolas',
	'GreenLeaf'
);

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Gimli',
	'Gloin'
);

INSERT INTO "Mechanic" (
	first_name,
	last_name
) VALUES (
	'Boromir',
	'Gondor'
);

SELECT *
FROM "Mechanic";

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	200.00,
	'Tire Replacement',
	'1000'
);

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	100.00,
	'Oil Change',
	'1001'
);

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	150.00,
	'Tire Rotation',
	'1002'
);

INSERT INTO "Service" (
	service_cost,
	service_type,
	"VIN_no"
) VALUES (
	220.00,
	'Break Replacement',
	'1003'
);

SELECT *
FROM "Service"

CREATE OR REPLACE FUNCTION add_customer(_customer_id INTEGER, _first_name VARCHAR, _last_name VARCHAR)
RETURNS TABLE(
	customer_id INTEGER,
	first_name VARCHAR,
	last_name VARCHAR
)
AS $MAIN$
BEGIN
	INSERT INTO "Customer"
	VALUES(_customer_id, _first_name, _last_name);
	RETURN QUERY SELECT *
	FROM "Customer"
	WHERE "Customer".customer_id = _customer_id;
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_customer(7, 'Bilbo', 'Baggins');



CREATE OR REPLACE FUNCTION add_invoice(invoice_id INTEGER, car_cost NUMERIC, service_cost NUMERIC, payment_type VARCHAR, VIN_no VARCHAR, customer_id INTEGER, car_id INTEGER, sales_person_id INTEGER)
RETURNS void
AS $$
BEGIN
	INSERT INTO "Invoice"
	VALUES(invoice_id, car_cost, service_cost, payment_type, VIN_no, customer_id, car_id, sales_person_id);
END;
$$
LANGUAGE plpgsql;

SELECT add_invoice('2', 200.00, 200.00, 'Cash', '1004', '2', '2', '2');

SELECT add_invoice('3', 4000.00, 0.00, 'Check', '1005', '3', '3', '3');

SELECT add_invoice('4', 1200.00, 0.00, 'Credit', '1006', '4', '1', '1');

SELECT *
FROM "Invoice";

ALTER TABLE "Cars"
ADD COLUMN is_serviced BOOLEAN;

CREATE OR REPLACE PROCEDURE is_serviced()
	LANGUAGE plpgsql
	AS $$
	BEGIN
		
		UPDATE "Cars"
		SET is_serviced = true
		WHERE car_id IN(
			SELECT car_id
			FROM "Invoice"
			GROUP BY "Invoice".car_id, "Invoice".service_cost
			HAVING "Invoice".service_cost > 0);
			
		UPDATE "Cars"
		SET is_serviced = false
		WHERE car_id IN(
			SELECT car_id
			FROM "Invoice"
			GROUP BY "Invoice".car_id, "Invoice".service_cost
			HAVING "Invoice".service_cost <= 0);
			
			COMMIT;
		END;
	$$

CALL is_serviced();

SELECT *
FROM "Cars";

SELECT add_invoice('5', 0.00, 1000.00, 'Credit', '1004', '4', '4', '1');

CALL is_serviced();

SELECT *
FROM "Cars"


