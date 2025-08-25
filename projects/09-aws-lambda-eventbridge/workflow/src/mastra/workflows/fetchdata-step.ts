import { createStep } from '@mastra/core/workflows';
import { z } from 'zod';
import { dataSchema } from '../../schema';
import { getData } from '../../utils/api';

export const fetchData = createStep({
    id: 'fetch-data',
    description: 'Fectch all data',
    inputSchema: z.object({}),
    outputSchema: z.array(dataSchema),
    execute: async ({ inputData }) => {
      if (!inputData) {
        throw new Error('Input data not found');
      }
      const response =  await getData();
      return response;
    },
});