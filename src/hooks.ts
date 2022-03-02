import prisma from '$lib/utils/prisma';
import type { GetSession, Handle } from '@sveltejs/kit';
import cookie from 'cookie';

export const getSession: GetSession = ({ locals, request }) => {
	const cookies = cookie.parse(request.headers.get('cookie') || '');
	const userId = cookies['userId'] ?? undefined;

	return locals.user
		? {
				userId,
				user: locals.user ?? undefined
		  }
		: {};
};

export const handle: Handle = async ({ event, resolve }) => {
	const cookies = cookie.parse(event.request.headers.get('cookie') || '');

	event.locals.userId = cookies.userId;

	if (event.locals.userId) {
		const user = await prisma.user.findUnique({
			where: {
				uid: event.locals.userId
			},
			include: {
				tasks: true,
				projects: true,
				habits: true
			}
		});

		if (user) {
			event.locals.userId = user.id;
			event.locals.user = user;
		}
	}
	const response = await resolve(event);

	return response;
};
