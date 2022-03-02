<script>
	import { createEventDispatcher, setContext } from 'svelte';
	import { fade } from 'svelte/transition';
	import { key } from './menu';

	export let x;
	export let y;

	$: (() => {
		if (!menuEl) return;

		const rect = menuEl.getBoundingClientRect();
		x = Math.min(window.innerWidth - rect.width, x);
		if (y > window.innerHeight - rect.height) y -= rect.height;
		// @ts-ignore
	})(x, y);

	const dispatch = createEventDispatcher();

	setContext(key, {
		dispatchClick: () => dispatch('click')
	});

	let menuEl;
	function onClose(e) {
		if (e.target === menuEl || menuEl.contains(e.target)) return;
		dispatch('clickoutside');
	}
</script>

<svelte:body on:click={onClose} />

<div
	class="absolute grid border-1 border-gray-800 shadow-md bg-white"
	transition:fade={{ duration: 100 }}
	bind:this={menuEl}
	style="top: {y}px; left: {x}px;"
>
	<slot />
</div>
