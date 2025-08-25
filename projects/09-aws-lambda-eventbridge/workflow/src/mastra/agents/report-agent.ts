import { google } from '@ai-sdk/google';
import { Agent } from '@mastra/core/agent';
import prompt from './prompt-2';

export const reportAgent = new Agent({
  name: 'Report Agent',
  instructions: prompt,
  model: google('gemini-2.0-flash-exp')
});