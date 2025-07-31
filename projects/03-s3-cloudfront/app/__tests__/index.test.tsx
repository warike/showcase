import '@testing-library/jest-dom'
import { render, screen } from '@testing-library/react'
import Home from '@/app/(landing)/_components/home'

describe('Home component', () => {
	beforeEach(() => {
		render(<Home />)
	})

	it('renders the title', () => {
		const title = screen.getByRole('heading', { name: "Warike technologies." })
		expect(title).toBeInTheDocument()
	})

	it('renders the subtitle', () => {
		const subtitleText = "Building world-class cloud solutions, setting standards of excellence and transforming lives through technology."
		expect(screen.getByText(subtitleText)).toBeInTheDocument()
	})

	it('renders the "Getting started" link with correct href', () => {
		const link = screen.getByRole('link', { name: /getting started/i })
		expect(link).toBeInTheDocument()
		expect(link).toHaveAttribute('href', 'https://www.warike.tech')
	})
})