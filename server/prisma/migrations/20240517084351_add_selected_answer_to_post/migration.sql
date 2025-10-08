-- AlterTable
ALTER TABLE "post" ADD COLUMN     "selected_answer_id" UUID;

-- AddForeignKey
ALTER TABLE "post" ADD CONSTRAINT "post_selected_answer_id_fkey" FOREIGN KEY ("selected_answer_id") REFERENCES "post"("id") ON DELETE SET NULL ON UPDATE CASCADE;
