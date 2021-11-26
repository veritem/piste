import prisma from '$lib/utils/prisma';
import type { Request, RequestHandler } from '@sveltejs/kit';
import { api } from './_api';

export const get: RequestHandler = async (req: Request) => {
	const data = await prisma.project.findMany({
		include: {
			user: true
		}
	});

	return {
		status: 200,
		body: { data }
	};
};

export const post: RequestHandler = async (req) => {
	let project = req.body;
	const response = await api(req, 'projects', project as any);

	console.log(response);

	return response;
};
