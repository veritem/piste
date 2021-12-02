<script lang="ts">
	export let text = '';
</script>

<div>
	{#if text}
		{text}
	{:else}
		<slot/>
	{/if}
</div>
