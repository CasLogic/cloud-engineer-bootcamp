# Azure Incident #003 - Apache Accessible Locally but Not Externally

## Category

Azure Networking

## Scenario

After installing Apache on the Ubuntu virtual machine, the web server worked locally but could not be reached from the Internet.

## Symptoms

- Apache service was running.
- localhost returned the Apache default page.
- External curl requests timed out.

## Initial Hypotheses

- Apache service failure.
- Firewall issue.
- Network Security Group blocking HTTP.
- Incorrect public IP.

## Investigation

- Verified Apache service status.
- Tested localhost connectivity.
- Confirmed the VM's public IP address.
- Reviewed Network Security Group inbound rules.

## Root Cause

The Network Security Group allowed SSH on port 22 but did not allow inbound HTTP traffic on port 80.

## Resolution

Created an inbound Network Security Group rule allowing TCP port 80.

## Validation

Successfully accessed the Apache web server using the VM's public IP address.

## Lessons Learned

- Verify services locally before troubleshooting cloud networking.
- A healthy application can still be inaccessible because of cloud firewall rules.
- Separate operating system troubleshooting from infrastructure troubleshooting.

## Skills Demonstrated

- Azure Network Security Groups
- Apache
- Linux Administration
- Cloud Networking
- Layered Troubleshooting

## Incident Status

Resolved