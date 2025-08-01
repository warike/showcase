import { createAzure } from '@ai-sdk/azure';
import { fetchLogger } from './logger';

const azure = createAzure({
  fetch: fetchLogger
});


export default azure;