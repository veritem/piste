import type { Request, RequestHandler } from '@sveltejs/kit';
import { api, Project } from './_api';

export const get: RequestHandler = async (req: Request) => {
	const response = await api(req, `projects`);

	if (response.status == 404) {
		return { body: [] };
	}
	return response;
};

export const post: RequestHandler = async (req) => {
	let project = req.body as Project;
	const response = await api(req, 'projects', {
		name: project.name,
		description: project.description
	});
	return response;
};
