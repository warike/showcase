# Warike demo app

## Configuration

Create nextjs app
`pnpm create t3-app@latest`

Install shadcn
`pnpm dlx shadcn@latest init`
`pnpm dlx shadcn@latest add button`

Install testing suite
`pnpm install -D jest jest-environment-jsdom @testing-library/react @testing-library/dom @testing-library/jest-dom ts-node @types/jest`
`pnpm create jest@latest`

Configure testing
```ts
const config: Config = {
  coverageProvider: "v8",
  moduleNameMapper: {
    '^@/components/(.*)$': '<rootDir>/components/$1',
  },
  setupFilesAfterEnv: [
    '<rootDir>/jest.setup.ts'
  ],
  testEnvironment: "jsdom",
};
```
- jest.setup.ts
`import '@testing-library/jest-dom'`
- package.json

```json
"test": "jest",
"test:watch": "jest --watch"
"test:ci": "jest --ci --runInBand --coverage",
```

- tsconfig.json
```json
"include": [
		"next-env.d.ts",
		"**/*.ts",
		"**/*.tsx",
		"**/*.cjs",
		"**/*.js",
		".next/types/**/*.ts", 
		"jest.config.ts"	],
"exclude": ["node_modules", ".next", "coverage"]
```