import { mastra } from "../src/mastra";

describe("Report Agent", () => {
    it("should generate a report", async () => {
        const run = await mastra.getWorkflow("reportWorkflow").createRunAsync();
        expect(run.workflowId).toBe("report-workflow");
    });
});