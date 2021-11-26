<script context="module" lang="ts">
	import type { Load } from '@sveltejs/kit';
	export const load: Load = async ({ fetch }) => {
		let res = await fetch('/app/projects.json');

		if (res.ok) {
			let resp = await res.json();
			return { props: { projects: resp.data } };
		}

		return { props: {} };
	};
</script>

<script lang="ts">
	import type { Project } from '@prisma/client';
	export let projects: Project[] = [];

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
			projects = [project, ...projects];
			project_name = '';
			project_description = '';
			return;
		}

		let { message } = await res.json();
		alert(message);
	}
</script>

<svelte:head>
	<title>Projects</title>
</svelte:head>

<section class="font-primary">
	<section class="flex space-x-8 pt-4">
		<aside class="w-44 shadow-sm  bg-primary">
			{#if projects.length > 0}
				<ul class="py-3 text-center px-2">
					{#each projects as project}
						<a
							href={`/app/projects/${project.id}`}
							class="py-2 rounded-sm hover:bg-pink text-white cursor-pointer"
						>
							{project.name}
						</a>
					{/each}
				</ul>
			{:else}
				<div class="text-white px-4 py-4">
					<p>no project added yet!</p>
				</div>
			{/if}
		</aside>
		<form class="flex flex-col gap-4" on:submit|preventDefault={handlesubmit}>
			<input
				type="text"
				placeholder="project name"
				class="rounded-sm"
				required
				bind:value={project_name}
			/>
			<input
				type="text"
				placeholder="project description"
				required
				class="rounded-sm"
				bind:value={project_description}
			/>
			<input
				type="submit"
				class="bg-primary text-white py-3 cursor-pointer rounded-md"
				value="save"
			/>
		</form>
	</section>
</section>
