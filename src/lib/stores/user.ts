import { writable } from 'svelte/store';

import supabase from '$lib/utils/db';

supabase.auth.onAuthStateChange((event, session) => {
	if (event == 'SIGNED_IN') {
		user.set(session.user);
	} else if (event == 'SIGNED_OUT') {
		user.set(null);
	} else if (event == 'USER_UPDATED') {
		user.update((user) => user);
	}
});

export const user = writable({});
