import type { Request, RequestHandler } from '@sveltejs/kit';
import { api } from './_api';

export const get: RequestHandler = async (req: Request) => {
	const response = await api(req, `projects`);

	if (response.status == 404) {
		return { body: [] };
	}
	return response;
};

export const post: RequestHandler<FormData> = async (req) => {
	const response = await api(req, `projects`, {
		body: req.body.get('name').toString()
	});
	return response;
};
