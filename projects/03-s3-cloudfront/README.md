### Deploy Next.js Application to Amazon CloudFront with S3

#### Why it is important?

Deploying static Next.js sites efficiently and securely is a common challenge for developers aiming for low-cost, scalable web hosting. This setup leverages Amazon S3 and CloudFront to serve static content globally with minimal overhead and strong performance.

* **Context:**  
  The project showcases a step-by-step deployment of a statically exported Next.js application to AWS. The site is hosted in an S3 bucket configured for static website hosting, and delivered globally via CloudFront. The process includes configuring necessary AWS resources as well as Github resources using Terraform.

* **Technology stack:**  
  - **Framework:** Next.js (with static export using `next export`)  
  - **Cloud Provider:** AWS  
  - **Services:** S3, CloudFront, Route 53 (optional), IAM, AWS CLI  
  - **Tools:** GitHub for source control

* **Learnings & Insights:**

  - Static export (`next export`) is an effective way to host Next.js apps without server-side rendering, reducing complexity and costs.
  - Configuring the S3 bucket properly (public access settings, static website hosting, correct object permissions) is critical for the deployment to work.
  - CloudFront acts as a CDN layer, improving latency and performance.
  - Setting proper cache behavior and MIME types in S3 is essential to avoid broken routes or MIME issues in the browser.
  - The use of IAM roles for deployment introduces a good practice in automating and securing deployments.

* **Status:** Completed.

* **Resources:** [Code & Details](#)