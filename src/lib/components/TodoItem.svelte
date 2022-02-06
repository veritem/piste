<script lang="ts">
	import type { Task } from '@prisma/client';
	export let task: Task;
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
				let task = await resp.json();
				//tasks = tasks.map((t) => (t.id === task.id ? task : t));
			}
		}}
	/>
	<label for={task.id} class={task.completed && 'line-through'}>{task.name} </label>
</div>
