import type { ServerResponse } from '@sveltejs/kit/types/hooks';
import supabase from '$lib/utils/db';

export async function post(): Promise<ServerResponse> {
	const { session } = await supabase.auth.signIn({
		provider: 'google'
	});

	return {
		status: 200,
		body: 'success',
		headers: {
			'set-cookie': `session=${
				session.user.email
			}; Path=/; HttpOnly; Secure; SameSite=Strict; Expires=${new Date(
				session.expires_at * 1000
			).toUTCString()};`
		}
	};
}
