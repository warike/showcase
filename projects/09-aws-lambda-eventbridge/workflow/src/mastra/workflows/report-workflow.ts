import { createWorkflow } from '@mastra/core/workflows';
import { z } from 'zod';
import { fetchData } from './fetchdata-step';
import { generateReport } from './generatereport-step';
import { sendReport } from './sendreport-step';


export const reportWorkflow = createWorkflow({
  id: 'report-workflow',
  inputSchema: z.object({}),
  outputSchema: z.object({}),
})
  .then(fetchData)
  .foreach(generateReport, { concurrency: 10 })
  .then(sendReport)
  .commit();
