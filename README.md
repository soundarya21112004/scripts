

1. **Clone Scripts from GitHub**:  
   Clone the required scripts repository from GitHub to your local machine.

   ```

   ```

2. **Set Full Permissions**:  
   After cloning, ensure all scripts have full permissions by running:  
   ```bash
   chmod 777 *.sh
   chmod 777 *.json
   ```

3. **Adjust IP Addresses**:  
   Modify the IP addresses in the `prerequirements.sh` script as needed for your environment.

4. **Execute the Script**:  
   Run the script on your local machine to copy the scripts to the respective target VMs.

5. **SSH to Target VMs**:  
   After the scripts are copied, SSH into the VMs manually.

6. **Execute Scripts on VMs**:  
   On each target VM, execute the respective scripts to install the necessary software and dependencies.

This sequence should help streamline your process for setting up the software across the different VMs. 
