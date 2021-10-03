<script context="module">
	export const ssr = false;
</script>

<script lang="ts">
	import '../app.postcss';

	import { browser } from '$app/env';
	import { goto } from '$app/navigation';
	import { user } from '$lib/stores/user';

	if (browser) {
		$user ? goto('/app') : goto('/');
	}
</script>

<slot />

<pre>{JSON.stringify($user,null,2)}</pre>
