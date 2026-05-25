The reason your previous attempts failed is actually because of a recent security update. The Jenkins project rotates its security keys every three years. The `jenkins.io-2023.key` you were using expired, and the repository was silently rejecting your connection.

Starting in **early 2026**, the official standard is to use the new `jenkins.io-2026.key`.

Here is the current, robust, production-standard script that DevOps engineers use to install the latest Jenkins Long-Term Support (LTS) release on Debian/Ubuntu.

### The 2026 Standard Jenkins LTS Install Script

Copy and paste this entire block into your terminal. It handles the prerequisites, fetches the correct modern security key, adds the stable repository, and installs Jenkins along with Java 21 (the current recommended version).

```bash
# 1. Update packages and install prerequisites
sudo apt update
sudo apt install -y ca-certificates curl gnupg apt-transport-https fontconfig openjdk-21-jre

# 2. Download the new 2026 Jenkins security key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | \
  sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# 3. Add the Jenkins LTS repository securely
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# 4. Update the package list to read the new repository
sudo apt update

# 5. Install Jenkins
sudo apt install -y jenkins

```

### Post-Installation Setup

Once the script finishes, you need to enable Jenkins to start on boot and then launch the service:

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins

```

You can verify that it is running correctly by checking its status:

```bash
sudo systemctl status jenkins

```

> **Note:** If you have a firewall running (like UFW), you will need to open port 8080 to access the web dashboard:
> `sudo ufw allow 8080`

To get your initial admin password for the web dashboard (accessible at `http://<your-server-ip>:8080`), run:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

```