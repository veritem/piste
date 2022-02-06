/// <reference types="@sveltejs/kit" />

import type { User } from '@prisma/client';

declare namespace App {
	interface Locals {
		user: User;
	}

	interface Platform {}

	interface Session {}

	interface Stuff {}
}
