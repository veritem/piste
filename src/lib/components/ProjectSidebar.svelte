<script lang="ts">
	import type { Project } from '@prisma/client';
	import Modal from './Modal.svelte';

	export let projects: Project[];

	let project_name = '';
	let project_description = '';

	async function handlesubmit() {
		let res = await fetch(`/app/projects.json`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ name: project_name, description: project_description })
		});

		if (res.ok) {
			let project = await res.json();
			projects = [project.data, ...projects];
			project_name = '';
			project_description = '';
			return;
		}

		let data = await res.json();
		alert(data.error);
	}

	export let activeProject = undefined;
	let openAddModel = false;
</script>

<aside class="w-72  shadow-sm px-4  bg-primary min-h-full font-primary">
	<button
		class="bg-secondary w-full py-2 text-white rounded-sm"
		on:click={() => {
			openAddModel = true;
		}}>Add project</button
	>

	{#if projects.length > 0}
		<ul class="py-3">
			{#each projects as project}
				<a
					href={`/app/projects/${project.id}`}
					class={`py-2 px-4 rounded-sm block hover:bg-secondary text-white cursor-pointer ${
						activeProject === project.id ? ' bg-secondary' : ''
					}`}
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

	<Modal open={openAddModel}>
		<h1 class="text-center font-bold text-2xl">Add a project</h1>

		<form
			class="flex flex-col gap-4  justify-center w-[20rem] pb-6 pt-2"
			on:submit|preventDefault={handlesubmit}
		>
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
				class="rounded-sm"
				bind:value={project_description}
			/>
			<input
				type="submit"
				class=" bg-secondary text-white py-3 cursor-pointer rounded-md"
				value="save"
			/>
		</form>
	</Modal>
</aside>
