import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async () => {
	return {
		status: 200,
		body: {
			message: 'Hello, World!'
		}
	};
};

export const patch: RequestHandler = async ({ params, request }) => {

	console.log("here")

	let { name, completed } = await request.json();


	const task = await prisma.task.update({
		where: { id: params.id },
		data: { name: name, completed }
	});

	return {
		status: 200,
		body: task
	};
};

export const del: RequestHandler = async ({ request, params }) => {

	return {
		status: 200,
		body: null
	};
};
