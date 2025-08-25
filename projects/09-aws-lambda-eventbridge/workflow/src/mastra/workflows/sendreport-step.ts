import { createStep } from '@mastra/core/workflows';
import { z } from 'zod';
import { sendTemplatedEmail } from '../../utils/ses';

export const sendReport = createStep({
  id: 'send-report',
  description: 'Send report by email',
  inputSchema: z.array(
    z.object({
        report: z.string(),
        email: z.string()
    })
  ),
  outputSchema: z.array(
    z.object({
      status: z.boolean(),
      message: z.string(),
      
    })
  ),
  execute: async ({ inputData }) => {

    try {
      if (!inputData) {
        throw new Error("Input data not found");
      }
  
      const results = await Promise.all(
        inputData.map(async ({ report, email }) => {
          if (!report) {
            return {
              status: false,
              message: "No report generated",
            };
          }
  
          try {
            await sendTemplatedEmail(email, "report_template", {
              report_text: report,
            });
  
            return {
              status: true,
              message: `Report sent to ${email}`,
            };
          } catch (err) {
            console.error("SES error:", err);
            return {
              status: false,
              message: `Failed to send report to ${email}: ${err}`,
            };
          }
        })
      );
  
      return results;
    } catch (error) {
      console.error("Error sending report:", error);
      throw error;
    }
  },
});