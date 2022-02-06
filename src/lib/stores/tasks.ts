import type { Task } from '@prisma/client';
import { writable } from 'svelte/store';

export const taskStore = writable<Task[]>([]);
