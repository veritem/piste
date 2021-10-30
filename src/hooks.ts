import cookie from 'cookie';

export function getSession(request) {
	return cookie.parse(request.headers.cookie || '').session || null;
}
