import { prisma } from '$lib/utils/db';
import type { EndpointOutput } from '@sveltejs/kit';

export async function get(): Promise<EndpointOutput> {
	const projects = await prisma.projects.findMany();
	return { body: JSON.stringify(projects) };
}
