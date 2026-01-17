BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "email" text NOT NULL,
    "phone" text NOT NULL,
    "age" bigint NOT NULL,
    "gender" text NOT NULL,
    "passwordHash" text NOT NULL,
    "name" text NOT NULL,
    "role" text NOT NULL,
    "skinType" text NOT NULL,
    "profilePhoto" text,
    "encryptionKey" text NOT NULL,
    "descriptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_log" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "action" text NOT NULL,
    "ip" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "descriptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "consent" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "type" text NOT NULL,
    "accepted" boolean NOT NULL,
    "encryptionKey" text NOT NULL,
    "descriptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "consultation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "doctorId" uuid NOT NULL,
    "checkId" uuid NOT NULL,
    "status" text NOT NULL,
    "doctorNotesKey" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "respondedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "doctor" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "name" text NOT NULL,
    "credentialsKey" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "licenseNumber" text NOT NULL,
    "verified" boolean NOT NULL,
    "rating" double precision NOT NULL,
    "availability" boolean NOT NULL,
    "fee" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "checkId" uuid NOT NULL,
    "url" text NOT NULL,
    "metadata" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "descriptionKey" text NOT NULL,
    "uploadedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "message" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "consultationId" uuid NOT NULL,
    "senderId" uuid NOT NULL,
    "senderType" text NOT NULL,
    "messageKey" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payment" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "consultationId" uuid NOT NULL,
    "amount" double precision NOT NULL,
    "status" text NOT NULL,
    "provider" text NOT NULL,
    "transactionId" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recommendation" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "checkId" uuid NOT NULL,
    "severity" text NOT NULL,
    "tipsKey" text NOT NULL,
    "warningsKey" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "symptom_check" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userId" uuid NOT NULL,
    "skinType" text NOT NULL,
    "symptoms" json NOT NULL,
    "affectedAreas" json NOT NULL,
    "duration" text NOT NULL,
    "severity" text NOT NULL,
    "notesKey" text NOT NULL,
    "encryptionKey" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "audit_log"
    ADD CONSTRAINT "audit_log_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "consent"
    ADD CONSTRAINT "consent_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "consultation"
    ADD CONSTRAINT "consultation_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "consultation"
    ADD CONSTRAINT "consultation_fk_1"
    FOREIGN KEY("doctorId")
    REFERENCES "doctor"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "consultation"
    ADD CONSTRAINT "consultation_fk_2"
    FOREIGN KEY("checkId")
    REFERENCES "symptom_check"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "doctor"
    ADD CONSTRAINT "doctor_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "image"
    ADD CONSTRAINT "image_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "image"
    ADD CONSTRAINT "image_fk_1"
    FOREIGN KEY("checkId")
    REFERENCES "symptom_check"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "message"
    ADD CONSTRAINT "message_fk_0"
    FOREIGN KEY("consultationId")
    REFERENCES "consultation"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "message"
    ADD CONSTRAINT "message_fk_1"
    FOREIGN KEY("senderId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "payment"
    ADD CONSTRAINT "payment_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "payment"
    ADD CONSTRAINT "payment_fk_1"
    FOREIGN KEY("consultationId")
    REFERENCES "consultation"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "recommendation"
    ADD CONSTRAINT "recommendation_fk_0"
    FOREIGN KEY("checkId")
    REFERENCES "symptom_check"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "symptom_check"
    ADD CONSTRAINT "symptom_check_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR skinaware
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('skinaware', '20260117135520909', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260117135520909', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
