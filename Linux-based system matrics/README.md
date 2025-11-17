# Grafana dashboard for monitoring linux-based system metrics
This repo contains Grafana dashboard I created to display system metrics such as CPU and Memory usage, etc of an ubuntu server.

I have provisioned the ubuntu server in AWS as an EC2 instance using Terraform. 

## Step by Step Guide
### 1. Provision the server
Deploy the server as an EC2 instance in your AWS account. You can have any region, CIDR block for VPC, subnets, AMI and other variables as you prefer.

Note: You must add your own access key and secret key in relevant variable blocks.

After configuring the files, run below commands to deploy the server.

```
terraform init
terraform plan
terraform apply --auto-approve
```

### 2. Install Docker

After the server is deployed, log into the server using the generated key file. Then copy and execute the install_docker.sh file to install Docker on the server.

Note: The file must have necessary executable permissions for the user.

### 3. Setup Prometheus, Grafana and Node Exporter as Docker containers.

First create a Docker Network

```
docker network create monitoring
```

#### Install Grafana as a Docker container

```
docker run -d --name=grafana --network monitoring -p 3000:3000 grafana/grafana
```

Explanation for Docker command:

-d: Runs the container in detached mode, allowing it to run in the background.

--name=grafana: Names the container “grafana” for easier management.

-p 3000:3000: Maps port 3000 on the Docker host to port 3000 on the container, making Grafana accessible at http://<docker-host-ip>:3000.

Access Grafana on Docker Host:

Open a browser and go to http://<docker-host-ip>:3000.
Log in with the default credentials: Username: admin | Password: admin. (You’ll be prompted to change the password after logging in.)

#### Create Prometheus configuration file
Create a prometheus.yml configuration file on your Docker host, defining the scrape targets.

```
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

#### Install Prometheus as a Docker Container

```
docker run -d --name=prometheus --network monitoring -p 9090:9090 -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```
Explanation for Docker command:

-v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml: Mounts the configuration file from the host to the container.

Access Prometheus:

Open a browser and go to http://<docker-host-ip>:9090 to access the Prometheus interface.

#### Install Node-Exporter as a Docker Container

Now we need to have the node exporter as a docker container. Node exporter is used to fetch the metrics of a linux-based system.

```
docker run -d --name node-exporter --network monitoring -p 9100:9100 prom/node-exporter
```
### 4. Setup the Data source

1. **Log in to Grafana**
   - Open your browser and go to: `http://<docker-host-ip>:3000`
   - Enter your credentials to log in (Initially its admin for both username and password)

2. **Navigate to Data Sources**
   - Click the **gear icon (⚙️)** in the left sidebar
   - Select **"Data Sources"**

3. **Add a New Data Source**
   - Click the **"Add data source"** button
   - Choose **"Prometheus"** from the list

4. **Configure Prometheus Settings in Connection section**
   - **Prometheus server URL**: Enter the Prometheus server URL (e.g., `http://prometheus:9090`)

5. **Test and Save**
   - Click **"Test"** to verify the connection
   - If successful, click **"Save & Test"**

### 5. Import Prebuilt Dashboard

1. **Create Dashboard**
   - In the home page of Grafana, select **Create your first dashboard**

2. **Import Dashboard**
   - Click the **plus icon (+)** in the left sidebar
   - Select **“Import”**
   - Enter **Dashboard ID: `1860`** (Node Exporter Full)
   - Click **“Load”**

3. **Configure Data Source**
   - Select your Prometheus data source
   - Click **“Import”**

4. **Save the Dashboard**