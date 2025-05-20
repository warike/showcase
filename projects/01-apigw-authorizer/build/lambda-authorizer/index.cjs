// File: lambda-authorizer/index.cjs
exports.handler = async (event) => {
    // Extensive logging of the received event
    console.log("COMPLETE AUTHORIZER EVENT:", JSON.stringify(event, null, 2));
    console.log("Received headers:", JSON.stringify(event.headers || {}, null, 2));
    
    try {
        // Case-insensitive verification of the header
        const headers = event.headers || {};
        const authHeader = headers.Authorization || headers.authorization;
        
        console.log(`Value of Authorization header: ${authHeader}`);
        
        if (authHeader === "admin") {
            console.log("AUTHORIZATION SUCCESSFUL");
            return {
                isAuthorized: true
            };
        } else {
            console.log(`AUTHORIZATION DENIED. Value received: ${authHeader}`);
            return {
                isAuthorized: false
            };
        }
    } catch (error) {
        console.error("Error in authorizer:", error);
        return {
            isAuthorized: false
        };
    }
};