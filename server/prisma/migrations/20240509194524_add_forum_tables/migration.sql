-- CreateTable
CREATE TABLE "tag" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "title" TEXT,
    "body" TEXT NOT NULL,
    "rich_text" JSONB NOT NULL,
    "parent_id" UUID,
    "user_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "slug" TEXT,
    "last_activity_date" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "post_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "title_when_no_parent" CHECK ((parent_id IS NULL AND title IS NOT NULL) OR parent_id IS NOT NULL),
    CONSTRAINT "slug_when_no_parent" CHECK ((parent_id IS NULL AND slug IS NOT NULL) OR parent_id IS NOT NULL)

);

-- CreateTable
CREATE TABLE "post_tag" (
    "post_id" UUID NOT NULL,
    "tag_id" INTEGER NOT NULL,

    CONSTRAINT "post_tag_pkey" PRIMARY KEY ("post_id","tag_id")
);

-- CreateTable
CREATE TABLE "comment" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "post_id" UUID NOT NULL,
    "user_id" UUID,
    "body" TEXT NOT NULL,
    "rich_text" JSONB NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post_vote" (
    "post_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "vote_type_id" SMALLINT NOT NULL,

    CONSTRAINT "post_vote_pkey" PRIMARY KEY ("post_id","user_id")
);

-- CreateTable
CREATE TABLE "comment_vote" (
    "comment_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "vote_type_id" SMALLINT NOT NULL,

    CONSTRAINT "comment_vote_pkey" PRIMARY KEY ("comment_id","user_id")
);

-- CreateTable
CREATE TABLE "vote_type" (
    "id" SMALLSERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "vote_type_pkey" PRIMARY KEY ("id")
);

-- CreateIndex-
CREATE UNIQUE INDEX "vote_type_name_key" ON "vote_type"("name");

-- CreateIndex
CREATE UNIQUE INDEX "tag_name_key" ON "tag"("name");

-- CreateIndex
CREATE INDEX "post_parent_id_idx" ON "post"("parent_id");

-- CreateIndex
CREATE INDEX "comment_post_id_idx" ON "comment"("post_id");

-- CreateIndex
CREATE INDEX "comment_user_id_idx" ON "comment"("user_id");

-- CreateIndex
CREATE INDEX "comment_vote_vote_type_id_idx" ON "comment_vote"("vote_type_id");

-- CreateIndex
CREATE INDEX "comment_vote_user_id_idx" ON "comment_vote"("user_id");

-- CreateIndex
CREATE INDEX "post_user_id_idx" ON "post"("user_id");

-- CreateIndex
CREATE INDEX "post_tag_tag_id_idx" ON "post_tag"("tag_id");

-- CreateIndex
CREATE INDEX "post_vote_vote_type_id_idx" ON "post_vote"("vote_type_id");

-- CreateIndex
CREATE INDEX "post_vote_post_id_vote_type_id_idx" ON "post_vote"("post_id", "vote_type_id");

-- CreateIndex
CREATE INDEX "post_vote_user_id_idx" ON "post_vote"("user_id");

-- CreateIndex
CREATE INDEX "post_created_at_idx" ON "post"("created_at");


-- CreateIndex
CREATE UNIQUE INDEX "post_vote_post_id_user_id_key" ON "post_vote"("post_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "comment_vote_comment_id_user_id_key" ON "comment_vote"("comment_id", "user_id");

-- AddForeignKey
ALTER TABLE "post" ADD CONSTRAINT "post_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_tag" ADD CONSTRAINT "post_tag_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_tag" ADD CONSTRAINT "post_tag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_vote" ADD CONSTRAINT "post_vote_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_vote" ADD CONSTRAINT "post_vote_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment_vote" ADD CONSTRAINT "comment_vote_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment_vote" ADD CONSTRAINT "comment_vote_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_vote" ADD CONSTRAINT "post_vote_vote_type_id_fkey" FOREIGN KEY ("vote_type_id") REFERENCES "vote_type"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment_vote" ADD CONSTRAINT "comment_vote_vote_type_id_fkey" FOREIGN KEY ("vote_type_id") REFERENCES "vote_type"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


INSERT INTO "vote_type" ("id","name") VALUES (1,'upvote');
INSERT INTO "vote_type" ("id","name") VALUES (2,'downvote');
INSERT INTO "vote_type" ("id","name") VALUES (3,'smiley');
INSERT INTO "vote_type" ("id","name") VALUES (4,'clap');
INSERT INTO "vote_type" ("id","name") VALUES (5,'heart');

