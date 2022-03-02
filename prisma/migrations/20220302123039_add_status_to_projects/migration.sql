-- CreateEnum
CREATE TYPE "ProjectStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'ARCHIVED');

-- AlterTable
ALTER TABLE "Project" ADD COLUMN     "status" "ProjectStatus" NOT NULL DEFAULT E'ACTIVE';

-- AlterTable
ALTER TABLE "Task" ALTER COLUMN "Sheduled" SET DEFAULT NOW() + interval  ' 1 ' day;
