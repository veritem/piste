<script lang="ts">
	import { modalStore } from '$lib/stores/modal';

	let open = false;

	modalStore.subscribe((value) => {
		open = value;
	});
</script>

<svelte:window
	on:keydown={(e) => {
		if (e.key == 'Escape') {
			open = false;
		}
	}}
/>

{#if open}
	<div class="fixed w-full h-full bg-overlay top-0 left-0 grid place-items-center font-primary">
		<div class="bg-white px-7 pt-4">
			<div class="text-right">
				<span
					class="text-3xl cursor-pointer hover:font-bold"
					on:click={() => {
						open = false;
					}}>&times;</span
				>
			</div>

			<slot />
		</div>
	</div>
{/if}
