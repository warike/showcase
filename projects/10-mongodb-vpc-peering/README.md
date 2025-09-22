### AWS and MongoDB Atlas: High-Performance Connection with VPC Peering and Terraform

#### Why it is important?

This project demonstrates a secure and efficient method for connecting private AWS infrastructure to a managed MongoDB Atlas database. By using VPC Peering, it establishes a private network connection, bypassing the public internet entirely. This enhances security, reduces latency, and provides a scalable, automated infrastructure solution using Terraform.

  * **Context:** The goal is to create a secure, private connection between an AWS Virtual Private Cloud (VPC) and a MongoDB Atlas cluster. The implementation uses Terraform to provision all necessary resources, including the VPC, subnets, a NAT Gateway, EC2 instances (for testing), the Atlas cluster, and the VPC Peering connection. The final test validates that only an instance within the private subnet can access the database.

  * **Technology stack:**

      * **Cloud Provider:** AWS
      * **Database Service:** MongoDB Atlas
      * **Infrastructure as Code:** Terraform
      * **AWS Services:** VPC, EC2, Subnets, Route Tables, NAT Gateway, Security Groups
      * **Tools:** MongoSH

  * **Learnings & Insights:**

      * VPC Peering is a straightforward way to create a secure network between AWS and MongoDB Atlas without complex configurations.
      * Terraform is highly effective for automating the end-to-end setup, ensuring infrastructure is reproducible and easy to manage.
      * Proper network planning, specifically defining non-overlapping CIDR blocks for the AWS VPC and Atlas network, is critical to prevent routing conflicts.
      * This architecture enforces a strong security posture by design, isolating the database from public access and only permitting connections from trusted, private application subnets.

  * **Status:** Completed.

  * **Resources:** `[Code & Details](https://medium.com/warike/aws-and-mongodb-atlas-high-performance-connection-with-vpc-peering-and-terraform-5cf450f6328a)`
