<script lang="ts">
	import { invalidate } from '$app/navigation';
	import type { Task } from '@prisma/client';

	export let task: Task;

	async function handleDelete() {
		console.log('task: ' + task.id);
		if (confirm('Are you sure you want to delete this task?')) {
			const resp = await fetch(`/app/projects/${task.projectId}/tasks/${task.id}.json`, {
				method: 'DELETE'
			});

			if (resp.ok) {
				invalidate(`/app/projects/${task.projectId}`);
			}
		}
	}
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

			if (resp.ok) {
				invalidate(`/app/projects/${task.projectId}`);
			}
		}}
	/>
	<label for={task.id}>{task.name} </label>
	<button on:click={handleDelete}>&times;</button>
</div>
