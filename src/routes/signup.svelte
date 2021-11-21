<script context="module">
	export async function load({ session }) {
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

	let email;
	let password;
	let names;

	async function signUp() {
		error = undefined;

		let data = new FormData();

		data.set('email', email);
		data.set('password', password);
		data.set('names', names);

		const response = await fetch('/api/signup', {
			method: 'POST',
			body: data
		});

		if (response.ok) window.location.href = '/app';
		else error = await response.text();
	}
</script>

<svelte:head>
	<title>signup</title>
</svelte:head>

<section class="grid place-items-center h-screen w-screen font-primary">
	<form on:submit|preventDefault={signUp} class="bg-primary px-10 py-12 w-[30rem] rounded-md">
		{#if error}
			<p class="text-red-400 text-center">{error}</p>
		{/if}

		<label for="names" class="text-white">Names</label>
		<input
			class="block p-2 rounded w-full"
			required
			id="names"
			name="names"
			type="text"
			bind:value={names}
			placeholder="John collision"
		/><br />

		<label for="email" class="text-white">Email</label>
		<input
			class="block p-2 rounded w-full"
			id="email"
			required
			name="email"
			type="email"
			placeholder="tim@apple.com"
			bind:value={email}
		/><br />
		<label for="password" class="text-white">Password</label>
		<input
			class="block p-2 rounded w-full"
			id="password"
			name="password"
			required
			type="password"
			placeholder="secret"
			bind:value={password}
		/><br />
		<button class="p-2 rounded block w-full bg-purple shadow-md text-white">Sign up</button>
	</form>
</section>
