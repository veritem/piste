import type { RequestHandler, Request } from '@sveltejs/kit';
import prisma from '$lib/utils/prisma';

export const get: RequestHandler = async (request: Request<Locals>) => {
	const habits = await prisma.habit.findMany({
		where: {
			userId: request.locals.userId
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
