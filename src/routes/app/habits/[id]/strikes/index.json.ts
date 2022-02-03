import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const post: RequestHandler = async ({ request, params }) => {
	const body = await request.json();

	let strike = await prisma.strike.create({
		data: {
			name: body.name ?? '',
			days: body.days ?? [],
			habitId: params.id
		}
	});

	return {
		status: 201,
		body: strike
	};
};

export const get: RequestHandler = async ({ params }) => {
	let strikes = await prisma.strike.findMany({
		where: {
			habitId: params.id
		}
	});

	return {
		status: 200,
		body: strikes
	};
};
