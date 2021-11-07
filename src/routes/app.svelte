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
	let modal;
	export let session;
</script>

<svelte:head>
	<title>Application</title>
</svelte:head>

<nav class="bg-purple-500 text-white flex justify-around py-4">
	<a href="/app" class="text-3xl font-primary">Piste</a>
	<form action="/api/logout" method="GET">
		<button class="bg-purple-900 px-8 py-2 rounded-sm shadow-md">logout</button>
	</form>
</nav>

<section class="grid place-items-center h-full pt-20 font-primary">
	<button
		class="bg-purple-900 text-white py-4 px-8 rounded-md shadow-md"
		on:click={() => modal.show()}>add strike</button
	>
	<Modal bind:this={modal}>
		<CreateStrike />
	</Modal>
</section>

<code><pre>{JSON.stringify(session.session, undefined, 2)}</pre></code>
