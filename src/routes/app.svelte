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
<form action="/api/logout" method="GET">
	<button>logout</button>
</form>

<h1>App here</h1>
