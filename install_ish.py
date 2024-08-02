import os
import subprocess

script_name = "autogit4unimoose.sh"

# Make the script executable
os.chmod(script_name, 0o755)

# Run the script
try:
    subprocess.run(["./"+script_name], check=True)
except subprocess.CalledProcessError:
    print("Error occurred while running the script.")
    print("Trying with sudo...")
    try:
        subprocess.run(["sudo", "./"+script_name], check=True)
    except subprocess.CalledProcessError:
        print("Error occurred even with sudo. Please check the script and try again.")
