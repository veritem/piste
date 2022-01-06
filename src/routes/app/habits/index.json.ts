import prisma from '$lib/utils/prisma';
import type { Request, RequestHandler } from '@sveltejs/kit';
import type { Locals } from 'src/global';

export const get: RequestHandler = async (request: Request<Locals>) => {
	const habits = await prisma.habit.findMany({
		where: {
			userId: request.locals.userId
		},
		include: {
			strikes: true
		}
	});

	return {
		status: 200,
		body: habits
	};
};

export const post: RequestHandler<Locals, FormData> = async (request: Request<Locals>) => {
	const { name } = JSON.parse(request.body);

	const habit = await prisma.habit.create({
		data: {
			name,
			userId: request.locals.userId
		}
	});

	return {
		status: 200,
		body: {
			habit
		}
	};
};
