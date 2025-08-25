import { runWorkflow } from './app';

// The handler function is the entry point for AWS Lambda.
// Lambda will invoke it with the event data and execution context.
export const handler = async (event: any, context: any) => {
    console.log('Lambda function invoked');
    console.log('Event:', JSON.stringify(event, null, 2));
    console.log('Context:', JSON.stringify(context, null, 2));

    try {
        // Call the main application logic.
        const result = await runWorkflow();
        console.log(process.memoryUsage());
        
        // Lambda expects a specific response format.
        // Return a 200 (success) status code and the result in the body.
        return {
            statusCode: 200,
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                message: 'Workflow executed successfully!',
                result: result,
            }),
        };
    } catch (error) {
        // In case of error, catch it and log it.
        console.error(' Error in handler:', error);
        
        // Return a 500 error code.
        // It's important to return a valid response even in case of error.
        return {
            statusCode: 500,
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                message: 'An error occurred during workflow execution.',
                error: error instanceof Error ? error.message : String(error),
            }),
        };
    }
};
