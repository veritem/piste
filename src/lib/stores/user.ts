import { writable } from 'svelte/store';
import { setAuthCookie, unsetAuthCookie } from '../auth';
import supabase from '$lib/utils/db';

supabase.auth.onAuthStateChange(async (event, session) => {
	if (event == 'SIGNED_IN') {
		user.set(session.user);
		await setAuthCookie(session);
	} else if (event == 'SIGNED_OUT') {
		user.set(null);
		unsetAuthCookie();
	} else if (event == 'USER_UPDATED') {
		user.update((user) => user);
		await setAuthCookie(session);
	}
});

export const user = writable({});
