import { render } from '@testing-library/svelte';
import { describe, expect, it } from 'vitest';
import Signin from '../routes/signin.svelte';

describe('Signin page', () => {
	it('Should render signin page', () => {
		const { getByText } = render(Signin);

		expect(() => getByText(/signin/i)).not.toThrow();
	});
});
