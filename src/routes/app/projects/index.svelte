<script context="module" lang="ts">
	import ProjectSidebar from '$lib/components/ProjectSidebar.svelte';
	import type { Project } from '@prisma/client';
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
    export let projects: Project[];

</script>

<svelte:head>
	<title>Projects</title>
</svelte:head>

<section class="font-primary flex space-x-8">
	<ProjectSidebar {projects} />
	<div class="py-5 grid place-content-center text-center w-full">
		<p class="text-xl">You have {projects.length} {projects.length > 1 ? 'projects' : 'project'}</p>
		<p class="font-bold">None is selected</p>
	</div>
</section>
