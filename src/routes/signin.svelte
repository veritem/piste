<script context="module">
	/* export async function load({ session }) { */
	/* 	if (Object.keys(session).length !== 0 && session.constructor !== Object) { */
	/* 		return { */
	/* 			status: 302, */
	/* 			redirect: '/app' */
	/* 		}; */
	/* 	} */
	/* 	return {}; */
	/* } */
</script>

<script lang="ts">
	import { goto } from '$app/navigation';

	let error: string;
	async function signIn(e) {
		error = undefined;
		const response = await fetch('/api/signin', {
			method: 'POST',
			body: new FormData(e.target)
		});

		if (response.ok) {
			window.location.pathname = '/app';
		} else {
			error = await response.text();
		}
	}
</script>

<svelte:head>
	<title>signin</title>
</svelte:head>

<section class="grid place-items-center h-screen w-screen">
	<form on:submit|preventDefault={signIn} class="bg-purple-600 px-10 py-12 w-[30rem] rounded-md">
		{#if error}
			<p class="text-red-300 text-center">{error}</p>
		{/if}

		<label for="email" class="text-white">Email</label>
		<input class="block p-2 rounded w-full" id="email" required name="email" type="email" /><br />
		<label for="password" class="text-white ">Password</label>
		<input
			class="block p-2 rounded w-full"
			id="password "
			required
			name="password"
			type="password"
		/><br />
		<button class="p-2 rounded block w-full bg-purple-900 shadow-md text-white">signin</button>
	</form>
</section>
