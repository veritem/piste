<script context="module">
	export async function load({ fetch }) {
		const resp = await fetch(`/app/habits.json`);

		if (resp.ok) {
			return {
				props: {
					habits: await resp.json()
				}
			};
		}

		return {
			props: {}
		};
	}
</script>

<script lang="ts">
	import Modal from "$lib/components/Modal.svelte";
	import HabitStore from '$lib/stores/habits';
	import type { Habit } from '@prisma/client';
	import { onMount } from 'svelte';

	export let habits: Habit[];

	onMount(() => {
	HabitStore.set(habits);
	})

	let modal;

	let name: string;
</script>

<svelte:head>
	<title>habits</title>
</svelte:head>

<section class="py-12 px-4">
	<div class="flex justify-end">
		<button class="bg-secondary py-4 px-6 rounded-md shadow-md" on:click={() => modal.show()}
			>add a new habit</button
		>
	</div>

	<section class="py-4 px-12 md:gap-4 gap-8 grid grid-cols-1 md:grid-cols-4 lg:grid-cols-5">
		{#each habits as habit}
			<a
				href={`/app/habits/${habit.id}`}
				class="shadow-sm px-4 py-5 block border-2 border-black rounded-sm"
			>
				<h2 class="capitalize font-bold">{habit.name}</h2>
				<p>{habit?.strikes.length} streaks</p>
			</a>
		{/each}
	</section>

		<Modal bind:this={modal}>
		<h1 class="capitalize font-bold mt-7">add a new habit</h1>

		<form
			class="flex flex-col gap-4 w-80 py-5"
			on:submit|preventDefault={async () => {
				const resp = await fetch('/app/habits.json', {
					method: 'POST',
					body: JSON.stringify({
						name
					})
				});

				if(resp.ok){
				 name = '';
				 let response = await resp.json();
				 habits.push(response.habit)
				 modal.hide();
				}
			}}
		>
			<label>
				<input type="text" placeholder="habit name" class="w-full" required bind:value={name} />
			</label>

			<button class="bg-secondary py-4 px-2 rounded-sm shadow-md" type="submit">add</button>
		</form>
	</Modal>

</section>
