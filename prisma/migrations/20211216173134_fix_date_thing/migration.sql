-- AlterTable
ALTER TABLE "Task" ALTER COLUMN "Sheduled" DROP NOT NULL,
ALTER COLUMN "Sheduled" SET DEFAULT NOW() + interval  ' 1 ' day;
