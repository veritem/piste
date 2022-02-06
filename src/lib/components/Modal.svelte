<script>
	export let open = false;
</script>

<svelte:window
	on:keydown={(e) => {
		if (e.key == 'Escape') {
			open = false;
		}
	}}
/>

{#if open}
	<div class="modal-wrapper grid place-items-center font-primary">
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

<style>
	/* //TODO: Modal here */
	.modal-wrapper {
		background-color: rgb(0, 0, 0);
		background-color: rgba(0, 0, 0, 0.6);
		position: fixed;
		width: 100%;
		height: 100%;
		top: 0;
		left: 0;
	}
</style>
