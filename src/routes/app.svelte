<script context="module">
	export async function load({ page, fetch, session, context }) {
		if (!session) {
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

<svelte:head>
	<title>Application</title>
</svelte:head>

<nav class="bg-purple-500 text-white flex justify-around py-4">

	<a href="/app" class="text-3xl">Piste</a>
		<form action="/api/logout" method="GET">
	<button class="bg-purple-900 px-8 py-2 rounded-sm shadow-md">logout</button>
</form>

</nav>

<section class="grid place-items-center">
	<p>Get started creating strikes</p>
	<button class="bg-purple-900 text-white py-4 px-8 rounded-md shadow-md">add a strike</button>
</section>


