import type { Handle } from '@sveltejs/kit';
import cookie from 'cookie';
import prisma from '$lib/utils/prisma';

export const getSession = (request: Request) => {
	const cookies = cookie.parse(request.headers.cookie || '');
	const session = cookies['userId'] ?? undefined;
	return session;
};

export const handle: Handle = async ({ request, resolve }) => {
	const cookies = cookie.parse(request.headers.cookie || '');

	request.locals.userId = cookies.userId;

	if (request.locals.userId) {
		const user = await prisma.user.findUnique({
			where: {
				uid: request.locals.userId
			}
		});

		if (user) {
			request.locals.userId = user.id;
		}
	}

	if (request.query.has('_method')) {
		request.method = request.query.get('_method').toUpperCase();
	}

	const response = await resolve(request);

	return response;
};
