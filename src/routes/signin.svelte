<script context="module">
	export async function load({ session }) {
		if (session) {
			return {
				status: 302,
				redirect: '/app'
			};
		}
		return {
 props: {}
		};
	}
</script>

<script lang="ts">
	let error: string;
	let email: string;
	let password: string;
	async function signIn() {
		error = undefined;
		if (!email || !password) {
			error = 'Please enter your email and password';
			return;
		}
		const response = await fetch('/api/signin', {
			method: 'POST',
			body: JSON.stringify({
				email,
				password
			})
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

<section class="grid place-items-center h-screen w-screen font-primary">
	<form on:submit|preventDefault={signIn} class="bg-primary px-10 py-12 w-[30rem] rounded-md">
		{#if error}
			<p class="text-red-300 text-center">{error}</p>
		{/if}

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
			required
			placeholder="secret"
			name="password"
			type="password"
			bind:value={password}
		/><br />
		<button class="p-2 rounded block w-full bg-secondary shadow-md text-white">signin</button>
	</form>
</section>
