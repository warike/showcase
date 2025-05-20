// File: lambda/index.cjs
exports.handler = async (event) => {
    // Complete log of the event for debugging
    console.log('COMPLETE EVENT:', JSON.stringify(event, null, 2));
    
    try {
        // Simplified response
        return {
            statusCode: 200,
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ 
                message: "Hello World! Authorization successful.",
                timestamp: new Date().toISOString()
            })
        };
    } catch (error) {
        console.error('Error in main Lambda function:', error);
        return {
            statusCode: 500,
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ 
                message: "Internal server error"
            })
        };
    }
};