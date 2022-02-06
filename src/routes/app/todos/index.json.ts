import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async ({ locals }) => {
	let tasks = await prisma.task.findMany({
		where: {
			userId: locals.userId,
			Sheduled: {
				gt: new Date(),
				lt: new Date(new Date().getTime() + 86400000)
			}
		},
		orderBy: {
			Sheduled: 'asc'
		}
	});

	return { status: 404, body: tasks };
};

export const post: RequestHandler = async ({ params }) => {
	return { status: 201, body: [] };
};
