<script>
	import Multiselect from './MultiSelect.svelte';
	import supabase from '$lib/utils/db';

	const daysOfTheWeek = [
		'Monday',
		'Tuesday',
		'Wednesday',
		'Thursday',
		'Friday',
		'Saturday',
		'Sunday'
	];

	let selected;

	let name;

	async function submit() {
		const { data,error } = await supabase.from('strikes').insert({ title: name, days: selected });
		if (error) {
			alert(error.message);
		}
		alert('Inserted');
		if(data) {
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
			class="block w-full px-2 py-3 border-b-2 border-purple-500  focus:outline-none"
			id="title"
			required
			placeholder="Enter title here"
		/><br />
		<div class="pb-10">
			<label for="tile">Days of the week</label>
			<Multiselect id="days" bind:value={selected} bind:selected>
				{#each daysOfTheWeek as day}
					<option value={day}>{day}</option>
				{/each}
			</Multiselect>
		</div>
		<input type="submit" class="w-full bg-purple-900 text-white px-4 py-3 rounded cursor-pointer" />
	</form>
</div>
