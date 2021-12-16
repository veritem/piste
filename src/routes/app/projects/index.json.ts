import prisma from '$lib/utils/prisma';
import type { Request, RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async (req: Request<Locals>) => {
	const data = await prisma.project.findMany({
		include: {
			user: true
		},
		orderBy: {
			createdAt: 'desc'
		},
		where: {
			userId: req.locals.userId
		}
	});

	return {
		status: 200,
		body: { data }
	};
};

export const post: RequestHandler<Locals, FormData> = async (req: Request<Locals>) => {
	console.log(req.locals.userId);

	if (!req.locals.userId) {
		return {
			status: 401,
			body: {
				error: 'Unauthorized'
			}
		};
	}

	let { name, description } = req.body;

	let data = await prisma.project.create({
		data: {
			name,
			description,
			userId: req.locals.userId
		}
	});

	return {
		status: 201,
		body: { data }
	};
};
