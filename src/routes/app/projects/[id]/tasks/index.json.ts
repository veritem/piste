import prisma from '$lib/utils/prisma';
import type { RequestHandler, Request } from '@sveltejs/kit';

export const post: RequestHandler = async (req: Request<Locals>) => {
	let { name } = req.body;
	const task = await prisma.task.create({
		data: { name, projectId: req.params?.id, userId: req.locals.userId }
	});

	return {
		status: 201,
		body: task
	};
};

export const get: RequestHandler = async ({ params }) => {
	let tasks = await prisma.task.findMany({ where: { projectId: params.id } });

	return {
		status: 200,
		body: tasks ?? []
	};
};
