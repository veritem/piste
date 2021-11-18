module.exports = {
	mode: 'jit',
	purge: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		colors: {
			primary: "#142F43",
			yellow: "FFAB4C",
			pink: "#FF5F7E",
			purple: "#B000B9",
			white: "#FFFFFF",
		},
		extend: {},
		fontFamily: {
			primary: ['Inter', 'sans-serif']
		}
	},
	plugins: [
		require('@tailwindcss/forms'),
	]
};

