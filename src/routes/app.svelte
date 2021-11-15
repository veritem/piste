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
	import {onMount} from "svelte"
	import supabase from "$lib/utils/db"

	let strikes;

	onMount(() => {
         supabase.from('strikes').select('*').then(res => {
			 strikes = res.body;
		 })
		console.log(strikes)
	})

	let modal;
//	export let session;
</script>

<svelte:head>
	<title>app</title>
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
<div class="w-36">
	<!--	<code><pre>{JSON.stringify(JSON.parse(strikes), null, 4)}</pre></code>-->
	<!--	{#each strikes as strike}
			<div>
                 <p>{strike.title}</p>
			</div>
	{/each}
	-->
</div>
