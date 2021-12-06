<script context="module">
	export async function load({ fetch }) {
		const resp = await fetch(`/app/strikes/habits.json`);

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
	import Modal from '$lib/components/Modal.svelte';
	import { onMount } from 'svelte';
	import type {Habit} from "@prisma/client"

	export let habits: Habit[];


	let modal;

	let name: string;
</script>

<svelte:head>
	<title>strikes</title>
</svelte:head>

<section>
	<h1>Stikes will go here</h1>

	<section>
		<p>A list of habits</p>
	</section>

	<button class="bg-secondary py-4 px-2 rounded-sm shadow-md" on:click={() => modal.show()}
		>add a new habit</button
	>

	<pre>{JSON.stringify(habits,null,2)}</pre>

	<Modal bind:this={modal}>
		<h1 class="capitalize font-bold mt-7">add a new habit</h1>

		<form
			class="flex flex-col gap-4 w-80 py-5"
			on:submit|preventDefault={async () => {
				const resp = await fetch('/app/strikes/habits.json', {
					method: 'POST',
					body: JSON.stringify({
						name
					})
				});
				const data = await resp.json();

				if (data.ok) {
					name = '';
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
