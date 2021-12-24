import prisma from '$lib/utils/prisma';
import type { Handle, Request } from '@sveltejs/kit';
import cookie from 'cookie';
import type { Locals } from './global';

export const getSession = (request: Request<Locals>) => {
	const cookies = cookie.parse(request.headers.cookie || '');
	const userId = cookies['userId'] ?? undefined;
	return {
		userId,
		user: request.locals.user ?? undefined
	};
};

export const handle: Handle = async ({ request, resolve }) => {
	const cookies = cookie.parse(request.headers.cookie || '');

	request.locals.userId = cookies.userId;

	if (request.locals.userId) {
		const user = await prisma.user.findUnique({
			where: {
				uid: request.locals.userId
			},
			include: {
				tasks: true,
				projects: true,
				habits: true
			}
		});

		if (user) {
			request.locals.userId = user.id;
			request.locals.user = user;
		}
	}

	if (request.query.has('_method')) {
		request.method = request.query.get('_method').toUpperCase();
	}

	const response = await resolve(request);

	return response;
};
