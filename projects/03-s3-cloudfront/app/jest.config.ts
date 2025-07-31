import type {Config} from 'jest';
import nextJest from 'next/jest.js';
 
const createJestConfig = nextJest({
  dir: './',
})

const config: Config = {
  // Indicates which provider should be used to instrument code for coverage
  coverageProvider: "v8",
  // A map from regular expressions to module names or to arrays of module names that allow to stub out resources with a single module
  moduleNameMapper: {
    '^@/components/(.*)$': '<rootDir>/components/$1',
  },
  setupFilesAfterEnv: [
    '<rootDir>/jest.setup.ts'
  ],
  testEnvironment: "jsdom",
};

export default createJestConfig(config)
