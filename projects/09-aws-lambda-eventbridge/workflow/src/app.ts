import { mastra } from "./mastra";

export async function runWorkflow() {
    try {
        console.log('🚀 Starting reportWorkflow...');
        
        const run = await mastra.getWorkflow("reportWorkflow").createRunAsync();
        const runResult = await run.start({
            inputData: {}
        });
        
        if (runResult.status === 'success') {
            console.log('✅ Workflow executed successfully:');
            console.log(runResult.result);
            return runResult.result;
        } else if (runResult.status === 'failed') {
            console.error('❌ Workflow error:');
            console.error(runResult.error);
            throw new Error(`Workflow failed: ${runResult.status}`);
        }else {
            console.warn('⚠️ Unknown workflow status:', runResult.status);
            throw new Error(`Unknown workflow status: ${runResult.status}`);
        }
    } catch (error) {
        console.error('💥 Fatal error running workflow:', error);
        throw error;
    }
    
}