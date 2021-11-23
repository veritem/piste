import type { RequestHandler } from '@sveltejs/kit';
import { api } from './_api';
import prisma from '$lib/utils/prisma';

export const patch: RequestHandler = async (request) => {
	return api(request, `projects/${request.params.id}`);
};

export const get: RequestHandler = async (request) => {
	console.log(request.params.id);

	let project = await prisma.projects.findFirst({
		where: {
			id: parseInt(request.params.id)
		}
	});

	if (project) {
		return { status: 200, body: project };
	}

	return { status: 404, body: { message: 'Project not found' } };
};

export const del: RequestHandler = async (request) => {
	return api(request, `projects/${request.params.id}`);
};
