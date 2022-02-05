<script context="module">
	export async function load({ fetch }) {
		const resp = await fetch('/app/todos.json');

		return {
			props: {
				todos: await resp.json()
			}
		};
	}
</script>

<script lang="ts">
	import TodoItem from '$lib/components/TodoItem.svelte';
	import TodoSideBar from '$lib/components/TodoSideBar.svelte';
	import type { Task } from '@prisma/client';

	export let todos: Task[];
</script>

<svelte:head>
	<title>todolist</title>
</svelte:head>

<section class="flex">
	<TodoSideBar />
	<section class="py-4 px-5 font-primary">
		<h3 class="font-bold text-2xl py-4">Todos</h3>
		<ul>
			{#each todos as todo}
				<TodoItem task={todo} />
			{/each}
		</ul>
	</section>
</section>
