/// <reference types="@sveltejs/kit" />

import type { User } from '@prisma/client';

interface Locals {
	userId: string;
	user: User;
}
