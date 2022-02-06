import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async ({ locals }) => {
	const data = await prisma.project.findMany({
		include: {
			user: true
		},
		orderBy: {
			createdAt: 'desc'
		},
		where: {
			userId: locals.userId
		}
	});

	return {
		status: 200,
		body: { data }
	};
};

export const post: RequestHandler = async ({ locals, request }) => {
	if (!locals.userId) {
		return {
			status: 401,
			body: {
				error: 'Unauthorized'
			}
		};
	}

	let body = await request.formData();

	let data = await prisma.project.create({
		data: {
			name: body.get('name').toString(),
			description: body.get('description').toString(),
			userId: locals.userId
		},
		include: {
			user: true,
			tasks: true
		}
	});

	return {
		status: 201,
		body: { data }
	};
};
