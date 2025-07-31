export default function HomeLayout({
    children,
}: Readonly<{ children: React.ReactNode }>) {
    return (
        <div className="bg-white">
            <div className="px-6 py-24 sm:px-6 sm:py-32 lg:px-8">
                {children}
            </div>
        </div>
    );
}