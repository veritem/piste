<script context="module">
	export function load({ session }) {

		if (!session) {
			return {
				redirect: '/signin',
				status: 302
			};
		}

		return {
			props: {}
		};
	}
</script>

<script>
	import Nav from '$lib/components/Nav.svelte';
</script>

<Nav />
<slot />
