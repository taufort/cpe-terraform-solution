# cpe-terraform-solution

Terraform repository with solutions to Terraform modules in https://github.com/taufort/cpe-terraform.

### Module 4 - AWS Cloud Security - Solution

Correction for this module: https://github.com/taufort/cpe-terraform/tree/main/04_cloud_security

You'll find three solutions for this module:
* The first solution is to use an inlined JSON AWS IAM policy in the `aws_sns_topic` resource directly. This solution
works fine but is not very easy to maintain because you're manipulating JSON directly. This solution can be found
in `04_cloud_security/solution_1` directory.
* The second solution is to use the `aws_iam_policy_document` datasource instead on an inline IAM policy. This solution 
is more user-friendly because you do not have to manipulate JSON directly (the JSON is generated thanks
to the `aws_iam_policy_document` datasource). This solution can be found in `04_cloud_security/solution_2` directory.
* The third solution is to use the `aws_sns_topic_policy` resource and the `aws_iam_policy_document` datasource. 
This solution can be found in `04_cloud_security/solution_3` directory. 

### Module 5 - AWS networking - Solution

Correction for this module: https://github.com/taufort/cpe-terraform/tree/main/05_networking

The solution can be found in several files:
* `vpc.tf` with the creation of the subnets with the right CIDR blocks;
* `routing.tf` with the creation of the route table associations between the subnets and the route tables;
* `nat.tf` will deal with the lifecycle of one NAT gateway in the public subnet in AZ a.

## Module 6 - Compute

Correction for this module: https://github.com/taufort/cpe-terraform/tree/main/06_compute

* The public bastion host and its configuration can be found in `bastion.tf` file. A key pair was
generated thanks to `ssh-keygen -f bastion_cpe_key` command, the content of the public key (file `bastion_cpe_key.pub`)
was then integrated within the `aws_key_pair` resource in the `public_key` argument. The private key file 
`bastion_cpe_key` was commited in the git repository, you should never do that in a real project.

* The private HTTP server that we will access thanks to an SSH tunnel from the Cloud9 instance 
is in `http_server.tf` file. This instance does not need a `key_name` as opposed to the bastion
host because we won't access this instance through SSH. Check out the `local_file` datasource used
to reference the shell file `cloud_init.sh` and insert it in the instance with the `user_data` 
argument.
  