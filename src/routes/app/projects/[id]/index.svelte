<script context="module">
	export async function load({ params, fetch }) {
		const tasks = await fetch(`/app/projects/${params.id}/tasks.json`);
		const res = await fetch(`/app/projects/${params.id}.json`);
		let projectsResp = await fetch('/app/projects.json');

		if (res.ok) {
			let projects = await projectsResp.json();
			return {
				props: {
					project: await res.json(),
					tasks: await tasks.json(),
					projects: projects.data
				}
			};
		}
		return {
			status: 302,
			redirect: '/app/projects'
		};
	}
</script>

<script lang="ts">
	import ProjectSidebar from '$lib/components/ProjectSidebar.svelte';
	import TodoItem from '$lib/components/TodoItem.svelte';
	import type { Project, Task } from '@prisma/client';
	export let project: Project;
	export let projects: Project[];
	export let tasks: Task[];

	let isTaskFormOpen = false;

	let taskName: string = '';

	async function updateProject() {
		let res = await fetch(`/app/projects/${project.id}.json`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				name: project.name,
				description: project.description
			})
		});
		if (res.ok) {
			project = await res.json();
		}
	}
</script>

<svelte:head>
	<title>{project.name}</title>
</svelte:head>

<section class="font-primary flex space-x-8">
	<ProjectSidebar {projects} />
	<section>
		<div class="py-4">
			<h3
				class="text-3xl font-bold outline-none focus:border-gray-200 focus:border"
				contenteditable="true"
				bind:innerHTML={project.name}
				on:change={updateProject}
			/>

			<p
				class="text-base focus:outline-none"
				contenteditable="true"
				bind:innerHTML={project.description}
			/>
		</div>

		<h5 class="font-bold py-4">Tasks</h5>

		{#if tasks.length > 0}
			{#each tasks as task}
				<TodoItem {task} />
			{/each}
		{:else}
			<p class="text-sm italic">No tasks</p>
		{/if}

		<button
			class="hover:text-pink py-4"
			on:click={() => {
				isTaskFormOpen = !isTaskFormOpen;
			}}
			><span class="text-2xl">{isTaskFormOpen ? ' - ' : ' + '}</span>{isTaskFormOpen
				? 'Close form'
				: 'Add task'}</button
		>

		{#if isTaskFormOpen}
			<form
				class="flex flex-col w-[20rem] px-5 gap-4"
				on:submit|preventDefault={async () => {
					const res = await fetch(`/app/projects/${project.id}/tasks.json`, {
						method: 'POST',
						headers: {
							'Content-Type': 'application/json'
						},
						body: JSON.stringify({
							name: taskName
						})
					});
					if (res.ok) {
						const task = await res.json();
						taskName = '';
						tasks = [...tasks, task];
						isTaskFormOpen = false;
					}
				}}
			>
				<input
					type="text"
					placeholder="task name"
					class="rounded-sm"
					required
					bind:value={taskName}
				/>
				<input
					type="submit"
					value="add task"
					class="py-2 bg-primary text-white cursor-pointer rounded-sm"
				/>
			</form>
		{/if}
	</section>
</section>
