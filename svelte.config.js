import vercel from '@sveltejs/adapter-vercel';
import preprocess from 'svelte-preprocess';
import { extractorSvelte, presetAttributify, presetIcons, presetUno, presetWebFonts } from 'unocss';
import Unocss from 'unocss/vite';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: [preprocess()],
	kit: {
		adapter: vercel(),
		vite: {
			plugins: [
				Unocss({
					theme: {
						colors: {
							primary: '#202020',
							secondary: '#ffd100',
							overlay: 'rgba(0, 0, 0,0.5)'
						},
						fontFamily: {
							primary: ['Outfit', 'sans-serif']
						}
					},
					extractors: [extractorSvelte],
					presets: [
						presetAttributify(),
						presetUno(),
						presetIcons(),
						presetWebFonts({
							provider: 'google',
							fonts: {
								sans: 'Outfit'
							}
						})
					]
				})
			]
		}
	}
};

export default config;
