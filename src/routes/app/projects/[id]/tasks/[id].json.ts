import type { RequestHandler } from '@sveltejs/kit';
import prisma from '$lib/utils/prisma';

export const get: RequestHandler = async () => {
	return {
		status: 200,
		body: {
			message: 'Hello, World!'
		}
	};
};

export const patch: RequestHandler = async ({ params, body }) => {
	let { name, completed } = body;

	const task = await prisma.task.update({
		where: { id: params.id },
		data: { name: name, completed }
	});

	return {
		status: 200,
		body: task
	};
};

export const del: RequestHandler = async () => {
	return {
		status: 200,
		body: null
	};
};
