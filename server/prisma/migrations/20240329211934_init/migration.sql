-- CreateEnum
CREATE TYPE "gender" AS ENUM ('BOY', 'GIRL', 'UNKNOWN');

-- CreateEnum
CREATE TYPE "pregnancy_type" AS ENUM ('SINGLE', 'TWIN', 'TRIPLET');

-- CreateEnum
CREATE TYPE "role" AS ENUM ('USER', 'ADMIN', 'DOCTOR');

-- CreateEnum
CREATE TYPE "provider" AS ENUM ('LOCAL', 'GOOGLE', 'ADMIN');

-- CreateEnum
CREATE TYPE "request_status" AS ENUM ('PENDING', 'APPROVED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "delivery_type" AS ENUM ('VAGINAL', 'CESAREAN', 'UNKNOWN');

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "password" CHAR(60),
    "provider" "provider" NOT NULL DEFAULT 'LOCAL',
    "role" "role" NOT NULL DEFAULT 'USER',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "social_id" TEXT,
    "username" TEXT NOT NULL,
    "display_name" TEXT NOT NULL,
    "avatar_path" TEXT,
    "avatar_updated_at" TIMESTAMPTZ(3),
    "avatar_upload_requested_at" TIMESTAMPTZ(3),

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification_request" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "expires" TIMESTAMPTZ(3) NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "retry" INTEGER NOT NULL DEFAULT 0,
    "user_id" UUID NOT NULL,
    "status" "request_status" NOT NULL DEFAULT 'PENDING',

    CONSTRAINT "verification_request_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_request" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMPTZ(3)  NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "retry" INTEGER NOT NULL DEFAULT 0,
    "user_id" UUID NOT NULL,
    "status" "request_status" NOT NULL DEFAULT 'PENDING',

    CONSTRAINT "password_reset_request_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile" (
    "id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "city_id" INTEGER,
    "name" TEXT,
    "bio" TEXT,
    "specialization_id" INTEGER,
    "date_of_birth" TIMESTAMPTZ(3),
    "is_pregnant" BOOLEAN DEFAULT false,
    "is_parent" BOOLEAN DEFAULT false,

    CONSTRAINT "profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pregnancy" (
    "id" SERIAL NOT NULL,
    "profile_id" INTEGER NOT NULL,
    "end_date" TIMESTAMPTZ(3),
    "due_date" TIMESTAMPTZ(3) NOT NULL,
    "last_period_date" TIMESTAMPTZ(3),
    "birth_given" BOOLEAN NOT NULL DEFAULT false,
    "delivery_type" "delivery_type" DEFAULT 'UNKNOWN',
    "type" "pregnancy_type" NOT NULL DEFAULT 'SINGLE',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,

    CONSTRAINT "pregnancy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fetus" (
    "id" SERIAL NOT NULL,
    "pregnancy_id" INTEGER NOT NULL,
    "gender" "gender" NOT NULL DEFAULT 'UNKNOWN',

    CONSTRAINT "fetus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "baby" (
    "id" SERIAL NOT NULL,
    "profile_id" INTEGER NOT NULL,
    "gender" "gender" NOT NULL DEFAULT 'UNKNOWN',
    "date_of_birth" TIMESTAMPTZ(3) NOT NULL,
    "birth_time" TIME,
    "name" TEXT NOT NULL,
    "birth_weight" SMALLINT,
    "birth_height" DOUBLE PRECISION,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "baby_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_agreement" (
    "id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "agreed_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_agreement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "city" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "city_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "specialization" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "specialization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fcm_token" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "token" TEXT NOT NULL,
    "user_id" UUID NOT NULL,

    CONSTRAINT "fcm_token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_activity" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMPTZ(3) NOT NULL,
    "token" TEXT NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_social_id_key" ON "user"("social_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- CreateIndex
CREATE UNIQUE INDEX "verification_request_user_id_key" ON "verification_request"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "password_reset_request_token_key" ON "password_reset_request"("token");

-- CreateIndex
CREATE UNIQUE INDEX "password_reset_request_user_id_key" ON "password_reset_request"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "profile_user_id_key" ON "profile"("user_id");

-- CreateIndex
CREATE INDEX "profile_city_id_idx" ON "profile"("city_id");

-- CreateIndex
CREATE INDEX "profile_specialization_id_idx" ON "profile"("specialization_id");

-- CreateIndex
CREATE INDEX "pregnancy_profile_id_idx" ON "pregnancy"("profile_id");

-- CreateIndex
CREATE INDEX "pregnancy_birth_given_profile_id_idx" ON "pregnancy"("birth_given", "profile_id");

-- CreateIndex
CREATE INDEX "pregnancy_is_active_profile_id_idx" ON "pregnancy"("is_active", "profile_id");

-- CreateIndex
CREATE INDEX "fetus_pregnancy_id_idx" ON "fetus"("pregnancy_id");

-- CreateIndex
CREATE INDEX "baby_profile_id_idx" ON "baby"("profile_id");

-- CreateIndex
CREATE INDEX "session_user_id_idx" ON "session"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_agreement_user_id_key" ON "user_agreement"("user_id");

-- CreateIndex
CREATE INDEX "user_agreement_user_id_idx" ON "user_agreement"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "fcm_token_token_key" ON "fcm_token"("token");

-- CreateIndex
CREATE UNIQUE INDEX "fcm_token_user_id_key" ON "fcm_token"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "session"("token");

-- AddForeignKey
ALTER TABLE "verification_request" ADD CONSTRAINT "verification_request_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_reset_request" ADD CONSTRAINT "password_reset_request_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile" ADD CONSTRAINT "profile_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile" ADD CONSTRAINT "profile_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "city"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile" ADD CONSTRAINT "profile_specialization_id_fkey" FOREIGN KEY ("specialization_id") REFERENCES "specialization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pregnancy" ADD CONSTRAINT "pregnancy_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fetus" ADD CONSTRAINT "fetus_pregnancy_id_fkey" FOREIGN KEY ("pregnancy_id") REFERENCES "pregnancy"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "baby" ADD CONSTRAINT "baby_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_agreement" ADD CONSTRAINT "user_agreement_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fcm_token" ADD CONSTRAINT "fcm_token_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddTrigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_update_user_updated_at
BEFORE UPDATE ON "user"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER tr_update_verification_request_updated_at
BEFORE UPDATE ON "verification_request"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER tr_update_password_reset_request_updated_at
BEFORE UPDATE ON "password_reset_request"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER tr_update_profile_updated_at
BEFORE UPDATE ON "baby"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();