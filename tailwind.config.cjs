const config = {
	mode: 'jit',
	purge: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		extend: {},
		fontFamily: {
			primary: ['Inter', 'sans-serif']
		}
	},
	plugins: []
};

module.exports = config;
