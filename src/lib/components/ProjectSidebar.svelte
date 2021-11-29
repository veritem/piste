<script lang="ts">
	import type { Project } from '@prisma/client';


	export let projects: Project[];

	/* let project_name = ''; */
	/* let project_description = ''; */

	/* async function handlesubmit() { */
	/* 	let res = await fetch(`/projects.json`, { */
	/* 		method: 'POST', */
	/* 		headers: { */
	/* 			'Content-Type': 'application/json' */
	/* 		}, */
	/* 		body: JSON.stringify({ name: project_name, description: project_description }) */
	/* 	}); */

	/* 	if (res.ok) { */
	/* 		let project = await res.json(); */
	/* 		projects = [project, ...projects]; */
	/* 		project_name = ''; */
	/* 		project_description = ''; */
	/* 		return; */
	/* 	} */

	/* 	let { message } = await res.json(); */
	/* 	alert(message); */
	/* } */
	export let activeProject = undefined;

</script>

<aside class="w-80 shadow-sm  bg-primary h-screen">
	{#if projects.length > 0}
		<ul class="py-3 px-4">
			{#each projects as project}
				<a
					href={`/app/projects/${project.id}`}
					class={`py-2 px-4 rounded-sm block hover:bg-pink text-white cursor-pointer ${
						activeProject === project.id ? ' bg-pink' : ''
					}`}
				>
					{project.name}
				</a>
			{/each}
		</ul>
	{:else}
		<div class="text-white px-4 py-4">
			<p>no project added yet!</p>
		</div>
	{/if}
	<!--<form class="flex flex-col gap-4 w-11/12 justify-center" on:submit|preventDefault={handlesubmit}>
			<input
				type="text"
				placeholder="project name"
				class="rounded-sm"
				required
				bind:value={project_name}
			/>
			<input
				type="text"
				placeholder="project description"
				required
				class="rounded-sm"
				bind:value={project_description}
			/>
			<input
				type="submit"
				class=" bg-purple text-white py-3 cursor-pointer rounded-md"
				value="save"
			/>
			</form>
-->
</aside>
