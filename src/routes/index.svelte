<script>
	import supabase from '$lib/utils/db';

	async function signin() {
		const { user, session, error } = await supabase.auth.signIn({
			provider: 'google'
		});

		if (error) {
			console.log({ error });
		}

		console.log({ user });
		console.log({ session });

		/* const { error } = await supabase.auth.signOut(); */
		/* /1* console.log({error}) *1/ */
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
