<script context="module">
	export async function load({ page, fetch, session, context }) {
		if (Object.keys(session).length === 0) {
			return {
				status: 302,
				redirect: '/app'
			};
		}
		return {};
	}
</script>

<script>
	let error;

	async function signUp(e) {
		error = undefined;

		const response = await fetch('/api/signup', {
			method: 'POST',
			body: new FormData(e.target)
		});

		if (response.ok) window.location = '/app';
		else error = await response.text();
	}
</script>

<svelte:head>
	<title>signup</title>
</svelte:head>

<section class="grid place-items-center h-screen w-screen">
	<form on:submit|preventDefault={signUp} class="bg-purple-600 px-10 py-12 w-[30rem] rounded-md">
		{#if error}
			<p class="text-red-400 text-center">{error}</p>
		{/if}

		<label for="names" class="text-white">Names</label>
		<input class="block p-2 rounded w-full" required id="names" name="names" type="text" /><br />

		<label for="email" class="text-white">Email</label>
		<input class="block p-2 rounded w-full" id="email" required name="email" type="email" /><br />
		<label for="password" class="text-white">Password</label>
		<input
			class="block p-2 rounded w-full"
			id="password"
			name="password"
			required
			type="password"
		/><br />
		<button class="p-2 rounded block w-full bg-purple-900 shadow-md text-white">Sign up</button>
	</form>
</section>
