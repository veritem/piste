<script context="module">
	export async function load({ session}) {
		if (session) {
			return {
				status: 302,
				redirect: '/'
			};
		}
		return {};
	}
</script>

<script>
	
	import { goto } from '$app/navigation';

	async function signin() {	
	let response = await fetch('/auth', { 
		 	method: 'POST', 
		}); 

		if (response.ok) { 
		 	goto('/app'); 
		} 
	}
</script>

<svelte:head>
	<title>Piste</title>
</svelte:head>

<main class="flex justify-center items-center h-screen w-screen">
	<button class="bg-blue-500 text-white px-10 py-3 rounded-md" on:click={signin}
		>continue with google</button
	>
</main>
