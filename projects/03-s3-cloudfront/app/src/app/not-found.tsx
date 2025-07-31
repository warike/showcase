import { Button } from '@/components/ui/button'
import Link from 'next/link'


export default function NotFound() {
  return (
    <main className="grid min-h-full place-items-center bg-white px-6 py-24 sm:py-32 lg:px-8">
      <div className="text-center">
        <p className="text-base font-semibold">404</p>
        <h1 className="mt-4 text-5xl font-semibold tracking-tight text-balance text-gray-900 sm:text-7xl">Page not found</h1>
        <p className="mt-6 text-lg font-medium text-pretty text-secondary-foreground sm:text-xl/8">My man, I couldn’t find the page you’re looking for.</p>
        <div className="mt-10 flex items-center justify-center gap-x-6">
          <Button asChild>
            <Link href="/" className="text-base font-semibold">Go back home</Link>
          </Button>
        </div>
      </div>
    </main>
  )
}