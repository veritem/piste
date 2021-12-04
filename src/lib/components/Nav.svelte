<nav class="bg-primary font-primary text-white flex justify-around items-center py-4">
	<a class="block uppercase" href="/app">piste</a>
	<ul class="flex space-x-4">
		<li><a href="/app/strikes">Strikes</a></li>
		<li><a href="/app/projects">Projects</a></li>
		<li><a href="/app/todos">Todo</a></li>
	</ul>
	<form action="/api/logout" method="GET">
		<button class="px-8 py-2 rounded-sm">logout</button>
	</form>
</nav>
