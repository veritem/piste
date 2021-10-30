import supabase from '$lib/utils/db';

export async function get() {
	const { error } = await supabase.auth.signOut();

	if (error) {
		return {
			status: 400,
			body: error.message
		};
	}

	return {
		status: 302,
		headers: {
			location: '/signin',
			'set-cookie': `session=; path=/; expires=0;`
		}
	};
}
