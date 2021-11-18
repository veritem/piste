import type { RequestHandler } from '@sveltejs/kit';
import { api } from './_api';

export const patch: RequestHandler = async (request) => {
	return api(request, `projects/${request.params.id}`);
};

export const del: RequestHandler = async (request) => {
	return api(request, `projects/${request.params.id}`);
};
