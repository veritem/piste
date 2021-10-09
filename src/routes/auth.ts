import type { Session } from '@supabase/supabase-js';
import type { ServerRequest, ServerResponse } from '@sveltejs/kit/types/hooks';

export async function post(request: ServerRequest): Promise<ServerResponse> {
	console.log(request.body);
	// const session: Session | null = (request.body.toString() as (Session | null);
	let session: Session;
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
