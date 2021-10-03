// import type { Request } from '@sveltejs/kit';

// export async function post(request: Request) {
// 	const user_session = request.body.get('session');

// 	return {
// 		status: 200,
// 		body: 'success',
// 		headers: {
// 			'set-cookie': `session=${
// 				user_session?.user?.email
// 			}; Path=/; HttpOnly; Secure; SameSite=Strict; Expires=${new Date(
// 				user_session.expires_at * 1000
// 			).toUTCString()};`
// 		}
// 	};
// }
