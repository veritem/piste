import type { RequestHandler, Request } from '@sveltejs/kit';
import prisma from '$lib/utils/prisma';

export const get: RequestHandler = async (request: Request<Locals>) => {
	const habit = await prisma.habit.findFirst({
		where: {
			id: request.params.id
		},
		include: {
			strikes: true
		}
	});

	return {
		status: 200,
		body: {
			...habit
		}
	};
};
