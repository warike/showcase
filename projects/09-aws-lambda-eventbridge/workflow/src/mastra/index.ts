
import { Mastra } from '@mastra/core/mastra';
import { reportWorkflow } from './workflows/report-workflow';
import { reportAgent } from './agents/report-agent';
import { logger } from '../utils/logger';

export const mastra = new Mastra({
  workflows: { reportWorkflow },
  agents: { reportAgent },
  logger: logger
});