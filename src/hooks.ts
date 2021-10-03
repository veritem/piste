/* eslint-disable */
import cookie from 'cookie';
import type { Request } from '@sveltejs/kit';

/** @type {import('@sveltejs/kit').GetSession} */
export function getSession(request: Request) {
	return cookie.parse(request.headers.cookie || '').session || null;
}
