<script context="module">
	export async function load({ page, fetch }) {
		const url = `/projects/${page.params.id}.json`;
		const res = await fetch(url);

		if (res.ok) {
			return {
				props: {
					project: await res.json()
				}
			};
		}
		return {
		   status: 302,
		   redirect: '/projects'
		};
	}
</script>

<script lang="ts">
	import type {Project} from "./_api"
	export let project: Project;
</script>

<svelte:head>
	<title>{project.name}</title>
</svelte:head>

<section>
	<section>
		<h5 class="text-3xl">{project.name}</h5>
		<button class="hover:text-pink py-4"><span class="text-2xl">+</span> Add task</button>
	</section>
</section>
