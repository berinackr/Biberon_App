

-- CreateTable
CREATE TABLE "post_type" (
    "id" SMALLSERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "post_type_pkey" PRIMARY KEY ("id")
);



-- CreateIndex
CREATE UNIQUE INDEX "post_type_name_key" ON "post_type"("name");

-- CreateIndex
CREATE INDEX "post_last_activity_date_idx" ON "post"("last_activity_date");


INSERT INTO "post_type" ("id", "name") VALUES (1, 'Question');
INSERT INTO "post_type" ("id", "name") VALUES (2, 'Answer');

-- AlterTable
ALTER TABLE "post" ADD COLUMN     "post_type_id" SMALLINT NOT NULL DEFAULT 1;

-- AddForeignKey
ALTER TABLE "post" ADD CONSTRAINT "post_post_type_id_fkey" FOREIGN KEY ("post_type_id") REFERENCES "post_type"("id") ON DELETE CASCADE ON UPDATE CASCADE;


