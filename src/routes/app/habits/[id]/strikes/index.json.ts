import type { RequestHandler, Request } from '@sveltejs/kit';
import prisma from '$lib/utils/prisma';

export const post: RequestHandler = async (req: Request) => {
	console.log(req.body);

	let strike = await prisma.strike.create({
		data: {
			name: req.body.name ?? '',
			days: req.body.days ?? [],
			habitId: req.params.id
		}
	});

	return {
		status: 201,
		body: strike
	};
};

export const get = async (req: Request) => {
	let strikes = await prisma.strike.findMany({
		where: {
			habitId: req.params.id
		}
	});

	return {
		status: 200,
		body: strikes
	};
};
