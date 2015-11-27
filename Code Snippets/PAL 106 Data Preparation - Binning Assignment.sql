-- cleanup
DROP TABLE "SIGNATURE";
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_DROP"('DEVUSER', 'P_BA');
DROP TABLE "DATA";
DROP TABLE "BINNED";

-- procedure setup
CREATE COLUMN TABLE "SIGNATURE" ("POSITION" INTEGER, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO "SIGNATURE" VALUES (1, 'DEVUSER', 'T_DATA', 'IN');
INSERT INTO "SIGNATURE" VALUES (2, 'DEVUSER', 'T_MODEL', 'IN');
INSERT INTO "SIGNATURE" VALUES (3, 'DEVUSER', 'T_PARAMS', 'IN');
INSERT INTO "SIGNATURE" VALUES (4, 'DEVUSER', 'T_RESULTS', 'OUT');

CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_CREATE"('AFLPAL', 'BINNINGASSIGNMENT', 'DEVUSER', 'P_BA', "SIGNATURE");

-- data setup
CREATE COLUMN TABLE "DATA" LIKE "T_DATA";
INSERT INTO "DATA" VALUES (1, 123456);
INSERT INTO "DATA" VALUES (2, 31654);

CREATE COLUMN TABLE "BINNED" LIKE "T_RESULTS";

-- runtime
DROP TABLE "#PARAMS";
CREATE LOCAL TEMPORARY COLUMN TABLE "#PARAMS" LIKE "T_PARAMS";

TRUNCATE TABLE "BINNED";

CALL "P_BA" ("DATA", "MODEL", "#PARAMS", "BINNED") WITH OVERVIEW;

SELECT * FROM "BINNED";