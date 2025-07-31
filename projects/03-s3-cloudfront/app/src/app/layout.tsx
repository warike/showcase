import "@/styles/globals.css";

import type { Metadata } from "next";
import { Geist } from "next/font/google";
import { appConfig } from "@/utils/config";

export const metadata: Metadata = {
	title: appConfig.title,
	description: appConfig.description,
	icons: [{ rel: "icon", url: "/favicon.ico" }],
	viewport: {
		width: "device-width",
		initialScale: 1.0,
	},
};

const geist = Geist({
	subsets: ["latin"],
	variable: "--font-geist-sans",
});

export default function RootLayout({
	children,
}: Readonly<{ children: React.ReactNode }>) {
	return (
		<html lang="en" className={`${geist.variable}`}>
			<body>{children}</body>
		</html>
	);
}
