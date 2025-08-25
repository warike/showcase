import { SESClient, SendTemplatedEmailCommand } from "@aws-sdk/client-ses";
import { env } from "../env";

let client: SESClient | null = null;
function getClient(): SESClient {
    if (!client) {
      client = new SESClient({
        region: env.AWS_REGION,
      
      });
    }
    return client;
}
export async function sendTemplatedEmail(
    to: string,
    templateName: string,
    templateData: Record<string, any>,
    from?: string
  ) {
    const ses = getClient();
    const source = from || env.EMAIL_FROM;
  
    const command = new SendTemplatedEmailCommand({
      Source: source,
      Destination: { ToAddresses: [to] },
      Template: templateName,
      TemplateData: JSON.stringify(templateData),
    });
  
    return ses.send(command);
  }