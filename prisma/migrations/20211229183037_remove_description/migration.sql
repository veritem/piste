-- AlterTable
ALTER TABLE "Project" ALTER COLUMN "description" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Task" ALTER COLUMN "Sheduled" SET DEFAULT NOW() + interval  ' 1 ' day;
