import prisma from '$lib/utils/prisma';
import type { RequestHandler, Request } from '@sveltejs/kit';

export const get: RequestHandler = async (req: Request<Locals>) => {
	let tasks = await prisma.task.findMany({
		where: {
			userId: req.locals.userId,
			Sheduled: {
				gt: new Date(),
				lt: new Date(new Date().getTime() + 86400000)
			}
		},
		orderBy: {
			Sheduled: 'asc'
		}
	});

	// if (project) {
	// 	return {status: 200, body: project};
	// }

	return { status: 404, body: tasks };
};

export const post: RequestHandler<Locals, FormData> = async (request) => {
	console.log(request.params);

	return { status: 201, body: [] };
};
