<script context="module">
	export const load = async ({ params, fetch }) => {
		const resp = await fetch(`/app/habits/${params.id}.json`);
		const strikes = await fetch(`/app/habits/${params.id}/strikes.json`);

		return {
			props: {
				habit: await resp.json(),
				strikes: await strikes.json()
			}
		};
	};
</script>

<script lang="ts">
	import CreateStrike from '$lib/components/CreateStrike.svelte';
	import Modal from '$lib/components/Modal.svelte';
	import type { Habit, Strike } from '@prisma/client';

	export let habit: Habit;
	export let strikes: Strike[];

	let modal;
</script>

<svelte:head>
	<title>{habit.name}</title>
</svelte:head>

<section class="py-5 px-10 font-primary">
	<h1 class="font-bold py-5 text-2xl">{habit.name}</h1>

	{#if strikes.length > 0}
		<h1>{strikes.length} strikes</h1>
	{:else}
		<p>No strikes</p>
	{/if}

	<div class="mt-5">
		<button
			class="bg-secondary py-2 px-5 rounded-sm"
			on:click={() => {
				modal.show();
			}}>add new strike</button
		>
	</div>

	{#if strikes.length > 1}
		<table class="border-collapse border border-gray-400 mt-10">
			<thead>
				<tr>
					<th class="border border-gray-300 px-6 py-5">Name</th>
					<th class="border border-gray-300 px-6 py-5">description</th>
					<th class="border border-gray-300 px-6 py-5">Days</th>
					<th class="border border-gray-300 px-6 py-5">Status</th>
				</tr>
			</thead>
			<tbody>
				{#each strikes as strike}
					<tr>
						<td class="border border-gray-300 px-6 py-5">{strike.name}</td>
						<td class="border border-gray-300 px-6 py-5">{strike.description}</td>
						<td class="border border-gray-300 px-6 py-5">{strike.days}</td>
						<td class="border border-gray-300 px-6 py-5">
							<input type="checkbox" />
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	{:else}
		<p class="py-4 italic">No strike yet</p>
	{/if}

	<Modal bind:this={modal}>
		<CreateStrike />
	</Modal>
</section>
