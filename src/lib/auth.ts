import type { AuthChangeEvent, Session } from '@supabase/supabase-js';

/* eslint-disable */
export async function setServerSession(event: AuthChangeEvent, session: Session): Promise<any> {
	console.log({ session });
	await fetch('/auth', {
		method: 'POST',
		headers: new Headers({ 'Content-Type': 'application/json' }),
		credentials: 'same-origin',
		body: JSON.stringify({ event, session })
	});
}

export const setAuthCookie = async (session: Session): Promise<unknown> =>
	await setServerSession('SIGNED_IN', session);
export const unsetAuthCookie = async (): Promise<unknown> =>
	await setServerSession('SIGNED_OUT', null);
