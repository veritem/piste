<script context="module" lang="ts">
	import type { Load } from '@sveltejs/kit';
	export const load: Load = async ({ fetch }) => {
		let res = await fetch('/app/projects.json');

		if (res.ok) {
			let resp = await res.json();
			return { props: { projects: resp.data } };
		}

		return { props: {} };
	};
</script>

<script lang="ts">
	import type { Project } from '@prisma/client';
	import ProjectSidebar from '$lib/components/ProjectSidebar.svelte';
	export let projects: Project[] = [];
</script>

<svelte:head>
	<title>Projects</title>
</svelte:head>

<section class="font-primary flex space-x-8">
	<ProjectSidebar  {projects} />
	<div class=" italic py-4 font-bold">
		<p>No project selected</p>
	</div>
</section>
