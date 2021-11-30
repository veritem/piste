import prisma from '$lib/utils/prisma';
import type { Project } from '@prisma/client';
import type { Request } from '@sveltejs/kit';

export async function api(request: Request, resource: string, data?: Project) {
	let status = 500;
	let body = {};

	switch (request.method.toUpperCase()) {
		case 'GET':
			body = await prisma.project.findMany();
			status = 200;
			break;
		case 'POST':
			body = status = 201;
			break;
		case 'PATCH':
			// body = await prisma.project.update({
			// 	data: data,
			// 	where: { id: resource.split('/').pop() }
			// })
			status = 200;
			break;
		case 'DELETE':
			await prisma.project.delete({
				where: {
					id: data.id
				}
			});
			status = 200;
			break;
	}

	// if (request.method !== 'GET' && request.headers.accept !== 'application/json') {
	// 	return {
	// 		status: 303,
	// 		headers: {
	// 			location: '/projects'
	// 		}
	// 	};
	// }

	console.log({ body });

	return {
		status,
		body
	};
}
