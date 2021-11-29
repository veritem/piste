module.exports = {
	mode: 'jit',
	purge: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		colors: {
			primary: '#202020',
			secondary: '#ffd100',
		},
		extend: {},
		fontFamily: {
			primary: ['Inter', 'sans-serif']
		}
	},
	plugins: [require('@tailwindcss/forms')]
};
