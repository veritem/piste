<script context="module">
  export async function load({ page, fetch, session, context }) {
    if (session) {
      return {
        status: 302,
        redirect: '/app'
      }
    }
    return {}
  } 
</script>


<script>
	async function signUp(e) {
		const response = await fetch('/api/signup', {
			method: 'POST',
			body: new FormData(e.target)
		});

		if (response.ok) window.location = '/app';
		else alert(await response.text());
	}
</script>

<form on:submit|preventDefault={signUp}>
	<label for="email">Email</label>
	<input class="block p-2 rounded" id="email" name="email" type="email" /><br />
	<label for="password">Password</label>
	<input class="block p-2 rounded" id="password" name="password" type="password" /><br />
	<button class="p-2 rounded block mx-auto">Sign Up</button>
</form>
