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
	async function signIn(e) {
		console.log(new FormData(e.target).get('email'));
		const response = await fetch('/api/signin', {
			method: 'POST',
			body: new FormData(e.target)
		});

		if (response.ok) console.log(response.status);
		else alert(await response.text());
	}
</script>

<form on:submit|preventDefault={signIn}>
	<label for="email">Email</label>
	<input class="block p-2 rounded" id="email" name="email" type="email" /><br />
	<label for="password">Password</label>
	<input class="block p-2 rounded" id="password" name="password" type="password" /><br />
	<button class="p-2 rounded block mx-auto">Login</button>
</form>
