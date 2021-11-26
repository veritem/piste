<script context="module">
	export async function load({ session }) {
		if (Object.keys(session).length === 0 && session.constructor === Object) {
			return {
				status: 302,
				redirect: '/signin'
			};
		}

		return {
			props: {
				session
			}
		};
	}
</script>

<script>
	import CreateStrike from '$lib/components/CreateStrike.svelte';
	import Modal from '$lib/components/Modal.svelte';
	/* import supabase from '$lib/utils/db'; */

	let modal;
</script>

<svelte:head>
	<title>app</title>
</svelte:head>

<section class="grid place-items-center h-full pt-20 font-primary">
	<button
		class="bg-purple-900 text-white py-4 px-8 rounded-md shadow-md"
		on:click={() => modal.show()}>add strike</button
	>
	<Modal bind:this={modal}>
		<CreateStrike />
	</Modal>
</section>
<!-- <div class="w-36">
	<!--	<code><pre>{JSON.stringify(JSON.parse(strikes), null, 4)}</pre></code>-->
<!--	{#each strikes as strike}
			<div>
                 <p>{strike.title}</p>
			</div>
	{/each}
</div>-->
