# Terraform Starter Project for Deploying a Windows EC2 Instance
Terraform Scripts to a get windows instance up and running


## One thing to make sure is the security group is setup correctly


This is what the default security group looks like

| Type          | Protocol      | Port Range  | Source           | Comments(Mine)  |            
| ------------- |:-------------:| -----------:|-----------------:|----------------:|   
| All Traffic   | ALL           | ALL         | [Security Group] | Any traffic that is from the source security group is allowed |


This is what the security groups should look like in order to get this to work.

| Type          | Protocol      | Port Range  | Source           | Comments(Mine)  |            
| ------------- |:-------------:| -----------:|-----------------:|----------------:|   
| All Traffic   | ALL           | ALL         | [Security Group] | Any traffic that is from the source security group is allowed |
| WinRM-HTTP (5985)   | TCP (6)           | 5985         | 0.0.0.0/0 | Allows any traffic from the internet to flow into the attached security groups |

Note
Should be using WinRm-Https
Will be adding that in shortly.

