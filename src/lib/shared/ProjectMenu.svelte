<script lang="ts">
	import Menu from '$lib/components/Menu.svelte';
	import type { Project } from '@prisma/client';

	export let project: Project;

	export let showMenu = false;

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
	<Menu {...pos} on:clickoutside={closeMenu} on:mouseout={closeMenu}>
		<div class="flex flex-col w-[10rem] gap-4 rounded-sm border-none">
			<button class="hover:bg-secondary py-3">edit project</button>
			<button class="hover:bg-secondary py-3">archive project</button>
		</div>
	</Menu>
{/if}

<!-- class="flex flex-col justify-center items-center w-full h-full" -->
<a
	href={`/app/projects/${project.id}`}
	on:contextmenu|preventDefault={onRightClick}
	class="py-2 px-4 rounded-sm block hover:bg-secondary text-white cursor-pointer"
>
	{project.name}
</a>
