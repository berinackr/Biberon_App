-- AlterTable
ALTER TABLE "post_tag" ADD COLUMN     "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- CreateIndex
CREATE INDEX "post_tag_tag_id_post_id_idx" ON "post_tag"("tag_id", "post_id");
