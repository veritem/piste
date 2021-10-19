import { writable } from 'svelte/store';
import supabase from '$lib/utils/db';
import type { User } from '@supabase/supabase-js';

supabase.auth.onAuthStateChange(async (event, session) => {
	if (event == 'SIGNED_IN') {
		user.set(session.user);
	} else if (event == 'SIGNED_OUT') {
		user.set(null);
	} else if (event == 'USER_UPDATED') {
		user.update((user) => user);
	}
});

export const user = writable<User | null>(null);
