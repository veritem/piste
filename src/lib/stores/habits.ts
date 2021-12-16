import type { Habit } from '@prisma/client';
import { writable } from 'svelte/store';

const habits = writable<Habit[]>([]);

export default habits;
