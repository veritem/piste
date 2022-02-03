import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async ({ locals, params }) => {
	const habit = await prisma.habit.findFirst({
		where: {
			id: params.id
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
