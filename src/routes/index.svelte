<script context="module">
	export async function load({ session }) {
		if (Object.keys(session).length === 0 && session.constructor === Object) {
			return {
				status: 302,
				redirect: '/signin'
			};
		}
		return {
			status: 302,
			redirect: '/app'
		};
	}
</script>

<svelte:head>
	<title>Piste</title>
</svelte:head>
