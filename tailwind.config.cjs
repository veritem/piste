module.exports = {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		backgroundColor: (theme) => ({
			...theme('colors'),
			primary: '#202020',
			secondary: '#ffd100'
		}),
		textColor: (theme) => ({
			...theme('colors'),
			primary: '#202020',
			secondary: '#ffd100'
		}),
		extend: {},
		fontFamily: {
			primary: ['Outfit', 'sans-serif']
		}
	},
	plugins: [require('@tailwindcss/forms')]
};
