/*
  Warnings:

  - Made the column `Sheduled` on table `Task` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Task" ALTER COLUMN "Sheduled" SET NOT NULL,
ALTER COLUMN "Sheduled" SET DEFAULT NOW() + interval  ' 1 ' day;
