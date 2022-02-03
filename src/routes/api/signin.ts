import supabase from '$lib/utils/db';
import type { RequestHandler } from '@sveltejs/kit';

export const post: RequestHandler = async ({ request }) => {
	let { email, password } = await request.json();

	const { session, error } = await supabase.auth.signIn({ email, password });

	if (error) {
		return {
			status: 400,
			body: error.message
		};
	}

	return {
		status: 200,
		headers: {
			'set-cookie': `userId=${
				session.user.id
			}; Path=/; HttpOnly; Secure; SameSite=Strict; Expires=${new Date(
				session.expires_at * 10000
			).toUTCString()};`
		}
	};
};
