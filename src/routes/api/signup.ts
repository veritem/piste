import supabase from '$lib/utils/db';
import type { RequestHandler } from '@sveltejs/kit';

export const post: RequestHandler = async ({ request }) => {
	const { email, password } = await request.json();

	const { session, error } = await supabase.auth.signUp({ email, password });

	if (error) {
		return {
			status: 400,
			body: error.message
		};
	}

	return {
		status: 200,
		body: 'success',
		headers: {
			'set-cookie': `session=${
				session.user.email
			}; Path=/; HttpOnly; Secure; SameSite=Strict; Expires=${new Date(
				session.expires_at * 10000
			).toUTCString()};`
		}
	};
};
