## Tasks
- Modify the `google_compute_instance` in a way it takes static ip only.
- Copy the private key generated by terraform  to all the machines
- Create a backend solution to store the terraform statefile. 
- Store the statefile under a folder called as `infrastate` inside the bucket.
- Mention the bucket name dynamically during the runtime(terraform apply)
- Explore a way where i can mention the know_hosts approval rather than giving as `yes`