-- cleanup
DROP TYPE "T_DATA";
DROP TYPE "T_PARAMS";
DROP TYPE "T_RESULTS";
DROP TYPE "T_HELPER";
DROP TABLE "SIGNATURE";
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_DROP"('DEVUSER', 'P_CI');
DROP VIEW "V_DATA";
DROP TABLE "RESULTS";
DROP TABLE "HELPER";

-- procedure setup
CREATE TYPE "T_DATA" AS TABLE ("ID" INTEGER, "LIFESPEND" DOUBLE, "NEWSPEND" DOUBLE, "INCOME" DOUBLE, "LOYALTY" DOUBLE);
CREATE TYPE "T_PARAMS" AS TABLE ("NAME" VARCHAR(60), "INTARGS" INTEGER, "DOUBLEARGS" DOUBLE, "STRINGARGS" VARCHAR(100));
CREATE TYPE "T_RESULTS" AS TABLE ("PC_ID" VARCHAR(50), "EIGENVALUE" DOUBLE, "CONDITION_INDEX" DOUBLE, "LIFESPEND" DOUBLE, "NEWSPEND" DOUBLE, "INCOME" DOUBLE, "LOYALTY" DOUBLE, "INTERCEPT" DOUBLE);
CREATE TYPE "T_HELPER" AS TABLE ("NAME" VARCHAR(50), "VALUE" DOUBLE);

CREATE COLUMN TABLE "SIGNATURE" ("POSITION" INTEGER, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO "SIGNATURE" VALUES (1, 'DEVUSER', 'T_DATA', 'IN');
INSERT INTO "SIGNATURE" VALUES (2, 'DEVUSER', 'T_PARAMS', 'IN');
INSERT INTO "SIGNATURE" VALUES (3, 'DEVUSER', 'T_RESULTS', 'OUT');
INSERT INTO "SIGNATURE" VALUES (4, 'DEVUSER', 'T_HELPER', 'OUT');

CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_CREATE"('AFLPAL', 'CONDITIONINDEX', 'DEVUSER', 'P_CI', "SIGNATURE");

-- data & view setup
CREATE VIEW "V_DATA" AS 
	SELECT "ID", "LIFESPEND", "NEWSPEND", "INCOME", "LOYALTY"
		FROM "PAL"."CUSTOMERS"
	;
CREATE TABLE "RESULTS" LIKE "T_RESULTS";
CREATE TABLE "HELPER" LIKE "T_HELPER";

-- runtime
DROP TABLE "#PARAMS";
CREATE LOCAL TEMPORARY COLUMN TABLE "#PARAMS" LIKE "T_PARAMS";
INSERT INTO "#PARAMS" VALUES ('THREAD_NUMBER', 4, null, null); -- default 1
INSERT INTO "#PARAMS" VALUES ('INCLUDE_INTERCEPT', 1, null, null); -- 1:yes; 0:no (default:1)
INSERT INTO "#PARAMS" VALUES ('SCALING', 1, null, null); -- 1:yes; 0:no (default:1)

TRUNCATE TABLE "RESULTS";
TRUNCATE TABLE "HELPER";

CALL "P_CI" ("V_DATA", "#PARAMS", "RESULTS", "HELPER") WITH OVERVIEW;

SELECT * FROM "RESULTS";
SELECT * FROM "HELPER";