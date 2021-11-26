<script context="module">
	export function load({ error, status }) {
		return {
			props: {
				title: status,
				message: error.message
			}
		};
	}
</script>

<script lang="ts">
	export let title;
	export let message;
</script>

<svelte:head>
	<title>{title}</title>
</svelte:head>

<div class="grid place-items-center h-screen w-screen">
	<p class="text-5xl">{title} | {message.split(':')[0]}</p>
</div>
