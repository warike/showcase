* ---
### Title? A Minimalist Strategy for Securing Cloud Services with Cloudflare and GCP
#### Why it is important?

In the cloud era, quickly exposing services is crucial, but it is equally important to protect them from unwanted traffic that can inflate costs and compromise security. This project demonstrates how a smart architecture and the combination of services from different providers can offer a robust, cost-efficient solution with low operational overhead.

* **Context:** This project details the secure creation and deployment of a web application on Google Cloud Run. The primary challenge addressed is protection against automated and malicious traffic in a pay-per-use model, using Cloudflare as the main shield and a Google Cloud Load Balancer that allows traffic only from Cloudflare, keeping the Cloud Run service isolated from public internet access.
* **Technology stack:** Next.js, Docker, Google Cloud Run, Google HTTP Load Balancer, Google Cloud Armor, Google Artifact Registry, Google Workload Identity Federation, Cloudflare (DNS, Proxy), Terraform, GitHub Actions.
* **Learnings & Insights:** 
  - Combining Cloudflare (for perimeter security and DDoS mitigation) with GCP services (Cloud Run for serverless execution, Load Balancer for distribution, and Cloud Armor for IP-level security policies) offers an effective defense-in-depth solution.
  - It's possible to achieve a secure, low-cost architecture without additional operational complexity (such as NATs or VPNs) by focusing on proper service configurations.
  - Automation via Terraform for infrastructure and GitHub Actions for CI/CD is crucial for maintaining agility and consistency in deployments.
  - AI assistants, like ChatGPT, provide a strong starting point and foundation for infrastructure configuration, but oversight from an expert is still essential for optimizing and validating the solution.
* **Status:** Completed.
* **Resources:** [Code & Details](url)
* ---