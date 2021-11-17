import { prisma } from '$lib/utils/db';
import type { Request } from '@sveltejs/kit';
import type { EndpointOutput } from '@sveltejs/kit';

export async function get(): Promise<EndpointOutput> {
	const projects = await prisma.projects.findMany();
	return { body: JSON.stringify(projects) };
}

export async function post(request: Request): Promise<EndpointOutput> {
	const project = await prisma.projects.create({
		data: {
			name: 'New Project',
			description: 'New Project Description',
			createdAt: new Date(),
			updatedAt: new Date()
		}
	});
	return { body: JSON.stringify(project) };
}
