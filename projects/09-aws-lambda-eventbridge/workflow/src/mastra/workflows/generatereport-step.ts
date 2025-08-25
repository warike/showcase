import { createStep } from '@mastra/core/workflows';
import { z } from 'zod';
import { dataSchema } from '../../schema';

export const generateReport = createStep({
  id: 'generate-report',
  description: 'Generate report to each user',
  inputSchema: dataSchema,
  outputSchema: z.object({
    report: z.string(),
  }),
  execute: async ({ inputData, mastra }) => {

    try {
      const agent = mastra?.getAgent('reportAgent');
      if (!agent) {
        throw new Error('Workflow error: Report agent not found');
      }

      const prompt = `<data>
      ${JSON.stringify(inputData, null, 2)}
      </data>`;
      const response = await agent.generate([{ role: "user", content: prompt }]);
      return {
        email: inputData.email,
        report: response.text,
      };
    } catch (error) {
      console.error("Error generating report:", error);
      
      // Re-throw to mark the step as failed
      throw error;
    }
    
    
  },
});