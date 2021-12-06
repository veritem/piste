import type { RequestHandler, Request } from '@sveltejs/kit';
import prisma from '$lib/utils/prisma';

export const get = () => {
	return {
		status: 200,
		body: 'Hello from Strikes'
	};
};

export const post: RequestHandler<Locals, FormData> = async (request: Request<Locals>) => {
	const habit = await prisma.habit.create({
		data: {
			name: request.body.name,
			userId: request.params.userId
		}
	});

	return {
		status: 200,
		body: {
			message: 'Hello from Strikes'
		}
	};
};
