<script context="module">
	export function load({ session }) {
		if (session.user || session.userId) {
			return {
				props: {
					user: session.user,
					userId: session.userId
				}
			};
		}

		return {
			redirect: '/signin',
			status: 302
		};
	}
</script>

<script lang="ts">
	import projects from '$lib/stores/projects';
	import type { User } from '@prisma/client';
	import { onMount } from 'svelte';
	export let user: User;

	onMount(() => {
		projects.set(user?.projects);
	});
</script>

<svelte:head>
	<title>app</title>
</svelte:head>

<section class="grid place-items-center h-full pt-20 font-primary">
	<h3 class="font-bold my-12">{user.name}</h3>
	<div class="grid grid-cols-3 gap-4">
		<a
			href="/app/projects"
			class="bg-primary w-40 h-52 flex justify-center items-center rounded-sm text-white"
			>{user.projects.length} projects</a
		>
		<a
			href="/app/todos"
			class="bg-primary w-40 h-52 flex justify-center items-center rounded-sm text-white"
			>{user.tasks.length} Tasks</a
		>
		<a
			href="/app/habits"
			class="bg-primary w-40 h-52 flex justify-center items-center rounded-sm text-white"
			>{user.habits.length} habits</a
		>
	</div>
</section>
