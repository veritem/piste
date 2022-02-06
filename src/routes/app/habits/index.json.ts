import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async ({ locals }) => {
	const habits = await prisma.habit.findMany({
		where: {
			userId: locals.userId
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

export const post: RequestHandler = async ({ locals, request }) => {
	const { name } = await request.json();

	const habit = await prisma.habit.create({
		data: {
			name,
			userId: locals.userId
		}
	});

	return {
		status: 200,
		body: {
			habit
		}
	};
};
