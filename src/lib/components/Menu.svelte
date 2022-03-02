<script lang="ts">
	import { createEventDispatcher, setContext } from 'svelte';
	import { fade } from 'svelte/transition';

	export let x: number;
	export let y: number;

	// whenever x and y is changed, restrict box to be within bounds
	$: (() => {
		if (!menuEl) return;

		const rect = menuEl.getBoundingClientRect();
		x = Math.min(window.innerWidth - rect.width, x);
		if (y > window.innerHeight - rect.height) y -= rect.height;
		//@ts-ignore
	})(x, y);

	const dispatch = createEventDispatcher();

	setContext(
		{},
		{
			dispatchClick: () => dispatch('click')
		}
	);

	let menuEl: HTMLElement;
	function onPageClick(e: MouseEvent) {
		if (e.target === menuEl || menuEl.contains(e.target as HTMLInputElement)) return;
		dispatch('clickoutside');
	}
</script>

<svelte:body on:click={() => onPageClick} />

<div transition:fade={{ duration: 100 }} bind:this={menuEl} style="top: {y}px; left: {x}px;">
	<slot />
</div>

<style>
	div {
		position: absolute;
		display: grid;
		border: 1px solid #0003;
		box-shadow: 2px 2px 5px 0px #0002;
		background: white;
		margin-top: 1rem;
	}
</style>
