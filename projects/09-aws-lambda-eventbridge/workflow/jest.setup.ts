import dotenv from 'dotenv';
dotenv.config({ quiet: true });

const originalLog = console.log;
console.log = (...args: any[]) => {
  if (typeof args[0] === 'string' && args[0].includes('[dotenv@')) {
    return;
  }
  originalLog(...args);
};

// Disable Mastra telemetry warnings for tests
(globalThis as any).___MASTRA_TELEMETRY___ = true;