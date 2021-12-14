<script context="module">
	export const load =async ({page, fetch}) => {
	const resp = await fetch(`/app/habits/${page.params.id}.json`);
        return {
			props: {
				habit: await resp.json()
			}
		};
	};
</script>


<script lang="ts">

	import type {Habit} from "@prisma/client"


	export let habit: Habit;


</script>


<svelte:head>
	<title>{habit.name}</title>
</svelte:head>


<section class="py-5 px-10 font-primary">
	<h1 class="font-bold py-5 text-2xl">{habit.name}</h1>
  
	{#if habit?.strikes.length > 0}
		<h1>{habit?.strikes.length} strikes</h1>
	{:else}
	   <p>No strikes</p>
	{/if}


	<table class="border-collapse border border-gray-400 mt-10">
     		<thead>
			<tr>
				<th class="border border-gray-300 px-6 py-5">Date</th>
				<th class="border border-gray-300 px-6 py-5">Strike</th>
			</tr>
		</thead>
		<tbody>
		   <td class="border border-gray-300 px-6 py-5">test</td>
		   <td class="border border-gray-300 px-6 py-5">test</td>
		</tbody>
	</table>
	
</section>
