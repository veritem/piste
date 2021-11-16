import { createClient } from '@supabase/supabase-js';
import { PrismaClient } from '@prisma/client';

const supabase = createClient(
	import.meta.env.VITE_SUPABASE_URL as string,
	import.meta.env.VITE_SUPABASE_ANON_KEY as string
);
export const prisma = new PrismaClient();
export default supabase;
