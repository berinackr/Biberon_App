-- CreateTable
CREATE TABLE "bookmarked_post" (
    "user_id" UUID NOT NULL,
    "post_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bookmarked_post_pkey" PRIMARY KEY ("user_id","post_id")
);

-- CreateIndex
CREATE INDEX "bookmarked_post_post_id_index" ON "bookmarked_post"("post_id");
CREATE INDEX "bookmarked_post_user_id_index" ON "bookmarked_post"("user_id");

-- AddForeignKey
ALTER TABLE "bookmarked_post" ADD CONSTRAINT "bookmarked_post_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookmarked_post" ADD CONSTRAINT "bookmarked_post_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE CASCADE;
