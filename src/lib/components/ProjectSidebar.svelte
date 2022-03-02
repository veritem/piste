<script lang="ts">
	import ProjectMenu from '$lib/shared/ProjectMenu.svelte';
	import { modalStore } from '$lib/stores/modal';
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

	let openAddModel;

	modalStore.subscribe((value) => {
		openAddModel = value;
	});
</script>

<aside class="w-72  shadow-sm px-4  bg-primary min-h-full font-primary">
	<button
		class="bg-secondary w-full py-2 text-white rounded-sm"
		on:click={() => {
			modalStore.update((value) => !value);
		}}>Add project</button
	>

	{#if projects.length > 0}
		<ul class="py-3">
			{#each projects as project}
				<ProjectMenu {project} />
			{/each}
		</ul>
	{:else}
		<div class="text-white px-4 py-4">
			<p>no project added yet!</p>
		</div>
	{/if}

	<Modal>
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
