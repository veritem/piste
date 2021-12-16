import type { Project } from '@prisma/client';
import { writable } from 'svelte/store';

export default writable<Project[]>();
