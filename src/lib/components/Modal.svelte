<script>
	let shown = false;
	export function show() {
		shown = true;
	}
	export function hide() {
		shown = false;
	}
</script>

<svelte:window
	on:keydown={(e) => {
	if (e.key == 'Escape') {
			hide();
		}
	}}
/>

{#if shown}
	<div class="modal-wrapper grid place-items-center font-primary">
		<div class="bg-white px-7 pt-4 ">
			<span class="close text-2xl" on:click={() => hide()}>&times;</span>
			<slot />
		</div>
	</div>
{/if}

<style>
	.modal-wrapper {
		background-color: rgb(0, 0, 0);
		background-color: rgba(0, 0, 0, 0.6);
		position: fixed;
		width: 100%;
		height: 100%;
		top: 0;
		left: 0;
	}

	.close {
		float: right;
		cursor: pointer;
	}
	.close:hover {
		font-weight: bold;
	}
</style>
