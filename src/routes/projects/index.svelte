<script context="module" lang="ts">
	import type { Load } from '@sveltejs/kit';
	export const load: Load = async ({ fetch }) => {
		let res = await fetch('/projects.json');

		if (res.ok) {
			let projects = await res.json();
			return {
				props: { projects }
			};
		}

		let { message } = await res.json();
		return {
			error: new Error(message)
		};
	};
</script>

<script lang="ts">
	import Nav from '$lib/components/Nav.svelte';
	import type { Project } from './_api';
	import projectsStore from "$lib/stores/projects"

	// fix issue with store
	

	export let projects: Project[];



	let project_name = '';
	let project_description = '';

	async function handlesubmit() {
		let res = await fetch(`/projects.json`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ name: project_name, description: project_description })
		});
		if (res.ok) {
			let project = await res.json();
			project.push(project);
			projectsStore.set(project.push(project));
			project_name = '';
			project_description = '';
		}

		let { message } = await res.json();
		alert(message);
		return { error: new Error(message) };
	}
</script>

<svelte:head>
	<title>Projects</title>
</svelte:head>

<section class="font-primary">
	<Nav />
	<section class="flex space-x-8 pt-4">
		<aside class="w-44 shadow-sm  bg-primary">
			<ul class="py-3 text-center px-2">
				{#each projects as project}
					<li class="py-2 rounded-sm hover:bg-pink text-white cursor-pointer">
						{project.name}
					</li>
				{/each}
			</ul>
		</aside>
		<form class="flex flex-col gap-4" on:submit|preventDefault={handlesubmit}>
			<input type="text" placeholder="project name" bind:value={project_name} />
			<input type="text" placeholder="project description" bind:value={project_description} />
			<input type="submit" class="bg-primary text-white py-3" />
		</form>
	</section>
</section>
