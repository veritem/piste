import { createClient } from '@supabase/supabase-js';
import Prisma, * as PrismaAll from '@prisma/client';

const supabase = createClient(
	import.meta.env.VITE_SUPABASE_URL as string,
	import.meta.env.VITE_SUPABASE_ANON_KEY as string
);
const PrismaClient = Prisma?.PrismaClient || PrismaAll?.PrismaClient;
export const prisma = new PrismaClient();
export default supabase;
