import prisma from '$lib/utils/prisma';
import type { GetSession } from '@sveltejs/kit';
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

export const handle = async ({ event, resolve, locals }) => {
	const response = await resolve(event);
	const cookies = cookie.parse(response.headers.get('cookie') || '');

	locals.userId = cookies.userId;

	if (locals.userId) {
		const user = await prisma.user.findUnique({
			where: {
				uid: locals.userId
			},
			include: {
				tasks: true,
				projects: true,
				habits: true
			}
		});

		if (user) {
			locals.userId = user.id;
			locals.user = user;
		}
	}

	if (response.url.search('_method')) {
		// response
		response.method = response.url.searchParams.get('_method').toUpperCase();
	}

	return response;
};
