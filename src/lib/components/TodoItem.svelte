<script lang="ts">
	import { taskStore } from '$lib/stores/tasks';
	import type { Task } from '@prisma/client';
	import { get } from 'svelte/store';
	export let task: Task;
	let tasks: Task[];

	$: tasks = get(taskStore);
</script>

<div>
	<input
		type="checkbox"
		id={task.id}
		class="rounded-full
                          border-gray-300
                          text-blue-600
                          shadow-sm
                          focus:border-blue-300
                          focus:ring
                          focus:ring-offset-0
                          focus:ring-blue-200
                          focus:ring-opacity-50"
		checked={task.completed}
		on:change={async () => {
			tasks = tasks.map((t) => (t.id === task.id ? task : t));
			let resp = await fetch(`/app/projects/${task.projectId}/tasks/${task.id}.json`, {
				method: 'PATCH',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					completed: !task.completed,
					name: task.name
				})
			});
		}}
	/>
	<label for={task.id} class={task.completed && 'line-through'}>{task.name} </label>
</div>
