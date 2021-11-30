import supabase from '$lib/utils/db';
import type { Request } from '@sveltejs/kit';

export async function post(request: Request) {
	let { email, password } = JSON.parse(request.body);

	const { session, error } = await supabase.auth.signIn({ email, password });

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
			'set-cookie': `userId=${
				session.user.id
			}; Path=/; HttpOnly; Secure; SameSite=Strict; Expires=${new Date(
				session.expires_at * 1000
			).toUTCString()};`
		}
	};
}
