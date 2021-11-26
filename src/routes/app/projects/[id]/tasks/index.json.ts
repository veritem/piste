import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const post: RequestHandler = async ({ params, body }) => {
	let { name } = body;
	const task = await prisma.task.create({
		data: { name: name, projectId: params?.id }
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
