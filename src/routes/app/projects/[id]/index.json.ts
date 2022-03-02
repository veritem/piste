import prisma from '$lib/utils/prisma';
import type { RequestHandler } from '@sveltejs/kit';

export const get: RequestHandler = async ({ params }) => {
	let project = await prisma.project.findFirst({
		where: {
			id: params.id
		}
	});

	if (project) {
		return { status: 200, body: { project } };
	}

	return { status: 404, body: { message: 'Project not found' } };
};

export const post: RequestHandler = async ({ params }) => {
	console.log(params);

	return { status: 201, body: [] };
};

export const put: RequestHandler = async ({ params, request }) => {
	let existsById = prisma.project.findFirst({
		where: {
			id: params.id
		}
	});

	if (!existsById) {
		return {
			status: 404,
			body: {
				message: 'Project not found'
			}
		};
	}

	const formData = await request.formData();

	let project = await prisma.project.update({
		where: {
			id: params.id
		},
		data: {
			name: formData.get('name').toString(),
			description: formData.get('description').toString()
		}
	});
	return {
		status: 200,
		body: project
	};
};

export const del: RequestHandler = async ({ params }) => {
	await prisma.project.delete({
		where: {
			id: params.id
		}
	});

	return {
		status: 200
	};
};
