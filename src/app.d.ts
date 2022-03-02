/// <reference types="@sveltejs/kit" />

declare namespace App {
	interface Locals {
		userId: string;
		user: import('@prisma/client').User;
	}

	interface Platform {}

	interface Session {}

	interface Stuff {}
}
