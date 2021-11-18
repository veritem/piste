import { prisma } from '$lib/utils/db';
import type { Request } from '@sveltejs/kit';

export type Project = {
	id: number;
	name: string;
	description: string;
	userId: string;
	createdAt: string;
	updatedAt: string;
};

export async function api(request: Request, resource: string, data?: Project) {
	// handle user not found on the request

	let status = 500;
	let body = {};

	switch (request.method.toUpperCase()) {
		case 'GET':
			body = await prisma.projects.findMany();
			status = 200;
			break;
		case 'POST':
			body = await prisma.projects.create({
				data: {
					name: data.name,
					description: data.description
				}
			});
			status = 201;
			break;
		case 'PATCH':
			body = await prisma.projects.update({
				data: data,
				where: { id: parseInt(resource.split('/').pop()) }
			});
			status = 200;
			break;
		case 'DELETE':
			await prisma.projects.delete({
				where: {
					id: data.id
				}
			});
			status = 200;
			break;
	}

	if (request.method !== 'GET' && request.headers.accept !== 'application/json') {
		return {
			status: 303,
			headers: {
				location: '/projects'
			}
		};
	}
	return {
		status,
		body
	};
}
