-- AddForeignKey
ALTER TABLE "post" ADD CONSTRAINT "post_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "post"("id") ON DELETE SET NULL ON UPDATE CASCADE;
