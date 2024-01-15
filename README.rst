Round-Island Bus Company Moves to Cloud: Take-Home Engineering Assignment
========================================================================= 

Thank  you  for your  interest  in  joining  our  company as  a  cloud
engineer. Completing  this take-home engineering assignment  will help
us learn about how you architect  and deploy software systems in cloud
environments and determine if you are suitable for this role.

You  should expect  to  spend  around **4-5  hours**  working on  this
assignment.   Your  solutions  should   demonstrate  your  ability  to
architect and  deploy scalable, reliable, and  cost-efficient software
systems with the following concepts and technologies:

- Linux
- Docker
- Kubernetes
- Google Cloud Platform (GCP)
- Infrastructure as Code (IaC)

Introduction
------------

Imagine you  are a new  cloud engineer for the  fictional Round-Island
Bus Company (RIBC) which provides public transport services throughout
Singapore. RIBC has decided to migrate its on-premise IT operations to
GCP. Your task for this assignment  is to help complete this migration
for several of RIBC's backend services, including:

1. Design of a deployment architecture using one or more GCP services,

2. Modification of service code to support this architecture,

3. Use  of  Terraform   or  Ansible  to  configure   and  perform  the
   deployment, and

4. Creation  of cost  estimates  for  the use  of  cloud resources  to
   support the deployment.

Rules and Guidelines
++++++++++++++++++++

When completing this assignment, please  adhere to the following rules
and guidelines:

1. Task instructions or restrictions are not necessarily indicative of
   best practices, but  are instead designed to allow  you to showcase
   your  ability to  successfully  navigate  unanticipated or  unusual
   real-world product or technical restrictions.

2. For  tasks that  require configuring  cloud resources  with an  IaC
   configuration, you  are not expected  to deploy these  resources or
   test your  configuration before submission  so as to not  incur any
   cloud  costs.   We will  take  into  account this  limitation  when
   evaluating your submission.

   For tasks requiring configuration of only Kubernetes resources, you
   may  use `Minikube  <https://minikube.sigs.k8s.io/docs/start/>`_ to
   test your solutions locally before submission.

3. You are  allowed to  use third-party sofware  and services  in your
   solutions,  as long  as  they  are licensed  under  an open  source
   license (e.g., Prometheus).

4. You  may  refer to  online  sources,  but  you  may not  copy  code
   verbatim. You should acknowlege  these sources where appropriate in
   source code and configuration file comments.

Part 1: RIBC Website
--------------------

.. note::

   Please  save your  solutions for  Part 1  in the  ``gce/solutions``
   folder.

   The website source code is located under ``gce/website``.

The main RIBC website at ribc.com.sg is implemented as a Python Django
application using a PostgreSQL database.

In the following tasks, you  will migrate the application and database
to  a  fleet of  Compute  Engine  instances  and Cloud  Load  Balancer
frontend.

On any  given day,  the RIBC website  receives roughly  1,000 visitors
every hour.

Task 1.1: Configure Networking
++++++++++++++++++++++++++++++

Write an  Ansible or  Terraform configuration to  configure a  new VPC
network  for RIBC.   The VPC  will  need one  or more  subnets in  the
``asia-southeast1`` region to support:

1. One or more Compute Engine instances hosting a PostgreSQL database,
   and

2. One or more Compute Engine instances hosting the RIBC website.

Additionally, all  traffic from Compute  Engine instances in  this VPC
network to the external Internet must be routed through a gateway with
a fixed static IP address.

For additional security, your configuration must also ensure:

1. External traffic can only connect to instances on ports 22, 80, and
   443.

   Furthermore,  traffic to  port 22  is  only allowed  from the  RIBC
   office IP range ``198.51.100.32/27``.

Task 1.2: Deploy PostgreSQL Database
++++++++++++++++++++++++++++++++++++

Write an Ansible or Terraform configuration to deploy PostgreSQL 16 to
a Compute Engine instance such that:

1. The instance has a fixed internal IP address.

2. Firewall rules only allow RIBC  website Compute Engine instances to
   access the PostgreSQL server.

3. Django migrations are applied when the configuration is deployed.

Task 1.3: Deploy RIBC Website
+++++++++++++++++++++++++++++

Write an Ansible or Terraform configuration to deploy the RIBC website
Django application  to a fleet  of Compute Engine instances  behind an
HTTPS load balancer such that:

1. The instance type and minimum  number of instances is sufficient to
   support the expected visitor load.

2. Each instance runs Ubuntu.

3. Each instance only exposes ports 80 and 443 for ingress.

4. The application **cannot** be deployed using Docker.

5. The HTTPS load balancer services a pre-defined static IP address.

6. The load balancer implements an HTTP-HTTPS redirect.

7. The fleet  scales based on the  serving capacity of the  HTTPS load
   balancer.

Task 1.4: Cost Estimation
+++++++++++++++++++++++++

Produce a cost estimate for deploying the cloud resources you proposed
configuring in  Tasks 1.1-1.3, excluding any  sustained-use discounts,
for 1 month (730 hours).

Please  save the  estimate as  a spreadsheet  or text  file under  the
solution folder.

Part 2: Moving to Kubernetes
----------------------------

RIBC  has  decided   to  shift  some  of  its   backend  workloads  to
Kubernetes. In  the following  tasks, you will  migrate some  of these
workloads to Kubernetes, and create a GKE cluster to host them.

Task 2.1: Configure a GKE Cluster
+++++++++++++++++++++++++++++++++

Write an  Ansible or  Terraform configuration to  configure a  new GKE
standard cluster for RIBC. The cluster must:

1. Be a regional cluster.

2. Be  deployed in  a new  VPC network  with separate  subnetworks for
   Nodes, Pods, and Services.

3. Have  node  pools  sufficient   to  host  the  scheduled  workloads
   configured in their subsequent tasks.

Save  your configuration  files  under the  ``k8s/solutions/task-2-1``
folder.
   
Task 2.2: Deploy PostgreSQL Database
++++++++++++++++++++++++++++++++++++

Configure one  or more  Kubernetes resources  to deploy  PostgreSQL to
your GKE cluster such that:

1. You   use    only   the    official   `PostgreSQL    docker   image
   <https://hub.docker.com/_/postgres>`_   and  your   own  Kubernetes
   resources, no third-party operators.

2. Storage is provided by a PeristentVolume.

3. The database can  be accessed by workloads outside  the cluster but
   still within the cluster VPC network.

4. The database only accepts connections from:

   a. Workloads you configure in the remaining Part 2 tasks.

   b. The IP range ``10.90.0.0/16``.

Save    your    Kubernetes    resource   YAML    files    under    the
``k8s/solutions/task2-2`` folder.
      
Task 2.3: Configure Database Backups
++++++++++++++++++++++++++++++++++++

Configure regular backups for the PostgreSQL database by:

1. Writing a  script in  the language  of your choice  to back  up the
   PersistentVolume resource created for the PostgreSQL deployment.

   The script  should, after  a successful run,  ensure that  the five
   most recent back-ups are retained.

2. Writing  a Dockerfile  to create  a  Docker image  for your  backup
   script.

3. Configuring a Kubernetes CronJob to  run the backup script every 24
   hours.

   For this subtask, you can reference your Docker image using the tag
   ``ribc-pg-backup``.

Save your script code, Dockerfile, and Kubernetes YAML files under the
``k8s/solutions/task2-3`` folder.

Task 2.4: Migrate a SystemD Service to Kubernetes
+++++++++++++++++++++++++++++++++++++++++++++++++

Once per  week, RIBC  runs a  script to produce  the schedule  and bus
route assignments for its drivers. Currently, the scheduling script is
deployed using a  systemd service and timer which you  can find in the
``k8s/ribc-scheduler`` folder.

For this task, migrate this workload to Kubernetes by:

1. Writing a Dockerfile to Dockerize the scheduling scripts.

2. Configure one or more Kubernetes resources to replicate the systemd
   script deployment.

   For this subtask, you can reference your Docker image using the tag
   ``ribc-scheduler``.

Save your updated  script code, Dockerfile, and  Kubernetes YAML files
under the ``k8s/solutions/task2-4`` folder.

Part 3: Migrating a Machine-Learning Workload to Kubernetes
-----------------------------------------------------------

Looking  to modernize  its operations,  RIBC has  deployed a  computer
vision  model to  detect  levels of  traffic  using cameras  installed
around the island to improve bus scheduling and routing efficiency.

Currently,  this model  is  deployed  as a  Python  application on  an
on-premises  server with  an  NVIDIA Tesla  T4  GPU.  The  application
accepts client  connections on a  UNIX datagram socket  that reference
image files  stored on  disk. In  the following  tasks, you  will help
migrate this application to a Kubernetes deployment using Google Cloud
PubSub and Google Cloud Storage.

Task 3.1: Document Protocol
+++++++++++++++++++++++++++

Unfortunately,  the original  RIBC engineer  who developed  the server
application did not  document the server request  or response datagram
formats. To begin,  refer to ``k8s/traffic-detection/server.py`` which
processes traffic detection requests from the UNIX socket. Then:

1. Reverse-engineer  and document  the request  and response  datagram
   formats in a text file at ``k8s/solutions/task3-1/protocol.txt``.

2. Note at least one security flaw  in this protocol in the above text
   file. 

Task 3.2: Propose Cloud-Enabled Implementation
++++++++++++++++++++++++++++++++++++++++++++++

In a  text file  at ``k8s/solutions/task3-2/protocol.txt``,  propose a
new implementation of the server  application using one or more Google
Cloud PubSub topics and Google  Cloud Storage. For each PubSub message
type you propose, document:

1. The name and type of each message attribute.

2. The message body format, if any.

Task 3.3: Implement Cloud-Enabled Server
++++++++++++++++++++++++++++++++++++++++

Copy    the    existing    implemetation   of    the    server    from
``k8s/traffic-detection``  to ``k8s/solutions/task3-3``  and implement
your  proposed protocol  from  Task 3.2.  You  may install  additional
Python packages to complete this task. The names and versions of these
packages  should be  included in  a ``requirements.txt``  file in  the
solution folder.

Task 3.4: Deploy to Kubernetes
++++++++++++++++++++++++++++++

Deploy your new version of the server from Task 3.3 by:

1. Configuring  Google Cloud  resources for  your server  by modifying
   your existing  IaC configuration  for the  GKE cluster  deployed in
   Task 2.1.

2. Writing a Dockerfile to produce a Docker image for your server from
   Task 3.3.

   You     should     place      this     Dockerfile     under     the
   ``k8s/solutions/task3-3`` folder.

3. Configuring  one  or  more  Kubernetes  resources  to  perform  the
   deployment. Your server should not use any service account keyfiles
   to authenticate to Google Cloud.  If necessary, you can modify your
   existing IaC configuration.

   You  should place  your Kubernetes  resource YAML  files under  the
   ``k8s/solutions/task3-4`` folder.
   
Task 3.5: Autoscale by GPU Utilization
++++++++++++++++++++++++++++++++++++++   

To  support increased,  unpredictable demand  for your  newly deployed
traffic  detection   server,  implement   autoscaling  based   on  GPU
utiliazation  by configuring  one  or more  Kubernetes resources.  You
should   place  your   Kubernetes  resource   YAML  files   under  the
``k8s/solutions/task3-5`` folder.

If necessary,  you may  install third-party  cluster add-ons  and make
changes  to  your  existing  IaC configuration  for  the  GKE  cluster
deployed  in  Task  2.1.
