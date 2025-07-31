"use client"

import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import Icons from "@/components/shared/icons";
import Link from "next/link";

export default function Home() {
    const title = "Warike technologies.";
    const subTitle = "Building world-class cloud solutions, setting standards of excellence and transforming lives through technology.";

    return (
        <div  className={cn("mx-auto max-w-3xl sm:max-w-7xl lg:max-w-4xl py-24 px-4 sm:py-32 sm:px-6 text-center")}>
			<h1 className={cn(
				"text-5xl font-semibold tracking-tight text-balance sm:text-6xl"
			)}>
            	{title}
            </h1>
			<p className="mx-auto mt-6 max-w-xl text-lg/8 text-pretty text-secondary-foreground">
				{subTitle}
			</p>
           
            <div className="mt-10 flex items-center justify-center gap-x-6">
				<Button className="w-full sm:w-auto" variant="default" asChild>
					<div>
						<Link href="https://www.warike.tech">Getting started</Link>
						<Icons.rocket className="ml-2 inline h-4 w-4" />
					</div>
				</Button>
            </div>
		</div>
    );
}