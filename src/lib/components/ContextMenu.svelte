<!-- 
//TODO:
	https://svelte.dev/repl/5527977f47a143c59d31c9ab3c60add5?version=3.25.0

-->
<script>
	import Menu from './Menu.svelte';
	import MenuOption from './MenuOption.svelte';
	let showMenu = false;

	let pos = { x: 0, y: 0 };

	async function onRightClick(e) {
		if (showMenu) {
			showMenu = false;
			await new Promise((res) => setTimeout(res, 100));
		}

		pos = { x: e.clientX, y: e.clientY };
		showMenu = true;
	}

	function closeMenu() {
		showMenu = false;
	}
</script>

{#if showMenu}
	<Menu {...pos} on:click={closeMenu} on:clickoutside={closeMenu}>
		<MenuOption text="Do nothing" on:click={console.log} />
		<MenuOption text="Do something!" on:click={console.log} />
	</Menu>
{/if}

<div on:contextmenu|preventDefault={onRightClick}>
	<slot />
</div>
