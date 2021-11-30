import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async (request) => {
	let project = await prisma.project.findFirst({
		where: {
			id: request.params.id
		}
	});

	if (project) {
		return { status: 200, body: project };
	}

	return { status: 404, body: { message: 'Project not found' } };
};

export const post: RequestHandler<Locals, FormData> = async (request) => {
	console.log(request.params);

	return { status: 201, body: [] };
};
