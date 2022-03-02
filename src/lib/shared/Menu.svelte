<script lang="ts">
	import { createEventDispatcher, setContext } from 'svelte';
	import { fade } from 'svelte/transition';
	import { key } from './menu';

	export let x: number;
	export let y: number;

	$: (() => {
		// if (!menuEl) return;
		// const rect = menuEl.getBoundingClientRect();
		// x = Math.min(window.innerWidth - rect.width, x);
		// if (y > window.innerHeight - rect.height) y -= rect.height;
		// @ts-ignore
	})(x, y);

	const dispatch = createEventDispatcher();

	setContext(key, {
		dispatchClick: () => dispatch('click')
	});

	// let menuEl;

	// function onClose(e: MouseEvent) {
	// 	if (e.target === menuEl || menuEl.contains(e.target)) return;
	// 	dispatch('clickoutside');
	// }
</script>

<!-- <svelte:body on:click={onClose} /> -->
<!-- bind:this={menuEl} -->

<div
	class="absolute grid border-1 border-gray-800 shadow-md bg-white"
	transition:fade={{ duration: 100 }}
	style="top: {y}px; left: {x}px;"
>
	<slot />
</div>
