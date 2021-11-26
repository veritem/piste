<script context="module">
	export async function load({ page, fetch }) {
		const tasks = await fetch(`/app/projects/${page.params.id}/tasks.json`);
		const res = await fetch(`/app/projects/${page.params.id}.json`);

		if (res.ok) {
			return {
				props: {
					project: await res.json(),
					tasks: await tasks.json()
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
	import type { Project, Task } from '@prisma/client';
	export let project: Project;
	export let tasks: Task[];

	let isTaskFormOpen = false;

	let taskName: string = '';
</script>

<svelte:head>
	<title>{project.name}</title>
</svelte:head>

<section class="font-primary px-4 py-5">
	<div class="py-4">
		<h3 class="text-xl font-bold">{project.name}</h3>

		<h4 class="text-base">{project.description}</h4>
	</div>

	<h5 class="font-bold py-4">Tasks</h5>

	{#each tasks as task}
		<div>
			<input
				type="checkbox"
				id={task.id}
				checked={task.completed}
				on:change={async () => {
					console.log('checked: ' + task.id);
					let resp = await fetch(`/app/projects/${project.id}/tasks/${task.id}.json`, {
						method: 'PATCH',
						headers: {
							'Content-Type': 'application/json'
						},
						body: JSON.stringify({
							completed: !task.completed,
							name: task.name
						})
					});

					if (resp.ok) {
						let task = await resp.json();
						tasks = tasks.map((t) => (t.id === task.id ? task : t));
					}
				}}
			/>
			<label for={task.id}>{task.name}</label>
		</div>
	{/each}

	<button
		class="hover:text-pink py-4"
		on:click={() => {
			isTaskFormOpen = !isTaskFormOpen;
		}}><span class="text-2xl">+</span> Add task</button
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
			<input type="text" placeholder="task name" required bind:value={taskName} />
			<input type="submit" value="add task" class="py-2 bg-primary text-white cursor-pointer" />
		</form>
	{/if}
</section>
