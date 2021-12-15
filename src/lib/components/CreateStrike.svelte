<script lang="ts">
	import Select from 'svelte-select';

	const items = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

	import { page } from '$app/stores';

	type Item = {
		label: string;
		value: string;
		index: number;
	};

	let selected: Item[];

	let name: string;

	async function submit() {
		const selectedItems = selected.map((item) => item.value);

		const response = await fetch(`/app/habits/${$page.params.id}/strikes.json`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ name, days: selectedItems })
		});

		if (response.ok) {
			selected = [];
			name = '';
		}
	}
</script>

<div class="font-primary px-3 py-5">
	<h3 class="font-bold py-4">Create a strike</h3>
	<form class="w-[25rem]" on:submit|preventDefault={submit}>
		<label for="tile">Title</label>
		<input
			type="name"
			bind:value={name}
			class="block w-full px-2 py-1 border-b-2 border-secondary focus:outline-none"
			id="title"
			required
			placeholder="Enter title here"
		/><br />
		<div class="pb-10">
			<label for="tile">Days of the week</label>
			<Select {items} isMulti={true} bind:value={selected} />
		</div>
		<input type="submit" class="w-full bg-secondary text-white px-4 py-3 rounded cursor-pointer" />
	</form>
</div>
