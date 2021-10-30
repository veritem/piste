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
	<title>Piste</title>
</svelte:head>
<h1>Home</h1>
