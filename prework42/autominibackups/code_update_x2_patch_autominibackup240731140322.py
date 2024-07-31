import os
import subprocess

# Paths to the scripts and files
scripts_dir = os.getcwd()
main_script = os.path.join(scripts_dir, "auto_git_unicorn_moose_feather_light_windmill_4_bash.sh")
update_github_about_script = os.path.join(scripts_dir, "update_github_about.py")
bashrc_file = os.path.expanduser("~/.bashrc")
kigit_file = os.path.join(scripts_dir, "kigit.txt")

# Ensure kigit.txt has the correct permissions
def fix_permissions():
    try:
        os.chmod(kigit_file, 0o644)
        print("Permissions for kigit.txt set to 644.")
    except Exception as e:
        print(f"Failed to set permissions for kigit.txt: {e}")

# Set git global configuration
def set_git_config():
    try:
        subprocess.run(["git", "config", "--global", "user.email", "you@example.com"], check=True)
        subprocess.run(["git", "config", "--global", "user.name", "Your Name"], check=True)
        print("Git global configuration set.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to set git global configuration: {e}")

# Remove redundant alias definitions
def clean_alias(alias, file):
    try:
        with open(file, 'r') as f:
            lines = f.readlines()
        with open(file, 'w') as f:
            for line in lines:
                if alias not in line:
                    f.write(line)
        print(f"Cleaned up old alias definitions from {file}.")
    except Exception as e:
        print(f"Failed to clean up alias definitions from {file}: {e}")

# Add alias to .bashrc
def add_alias(alias, command, file):
    clean_alias(alias, file)
    try:
        with open(file, 'a') as f:
            f.write(f"\nalias {alias}='{command}'\n")
        print(f"Alias '{alias}' added to {file}.")
    except Exception as e:
        print(f"Failed to add alias to {file}: {e}")

# Source .bashrc
def source_bashrc(file):
    try:
        subprocess.run(['bash', '-c', f'source {file}'], check=True)
        print(f"Sourced {file} successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to source {file}: {e}")

# Create update_github_about.py if it doesn't exist
def create_update_github_about_script():
    if not os.path.exists(update_github_about_script):
        try:
            with open(update_github_about_script, 'w') as f:
                f.write("""import os
import requests

def update_github_about():
    repo_name = os.getenv('GITHUB_REPOSITORY', 'AutoGit_UnicornMoose_FeatherLightWindmill_of_mtlmbsm')
    github_username = os.getenv('GITHUB_USERNAME', 'your_username')
    token = os.getenv('GITHUB_TOKEN', 'your_token')

    url = f"https://api.github.com/repos/{github_username}/{repo_name}"
    headers = {'Authorization': f'token {token}'}
    data = {
        "name": repo_name,
        "homepage": f"https://{github_username}.github.io/{repo_name}",
        "description": "A repository for automating GitHub setup and updates.",
    }
    
    response = requests.patch(url, headers=headers, json=data)
    if response.status_code == 200:
        print("Repository 'About' section updated successfully.")
    else:
        print(f"Failed to update repository 'About' section: {response.status_code}")

if __name__ == "__main__":
    update_github_about()
""")
            print(f"{update_github_about_script} created successfully.")
        except Exception as e:
            print(f"Failed to create {update_github_about_script}: {e}")
    else:
        print(f"{update_github_about_script} already exists.")

# Update main script
def update_main_script():
    try:
        with open(main_script, 'w') as f:
            f.write("""#!/bin/bash

# Main script to orchestrate other scripts
# Include other scripts
source ./config_handler.sh
source ./error_handler.sh
source ./github_setup.sh
source ./git_operations.sh
source ./bashrc_update.sh

# Main script logic
read_config
if [ ! -d ".git" ]; then
    log "Git is not initialized. Proceeding to setup the repository."
    setup_github_repo
else
    log "Git is already initialized."
    if [ "$update_flag" == "y" ]; then
        log "Update flag is set to 'y'. Proceeding to setup the repository."
        setup_github_repo
    else
        log "Update flag set to 'n'. Syncing repository."
        sync_github_repo
    fi
fi

if [ "$auto_page_trigger" = true ] || [ ! -f "index.html" ]; then
    log "index.html not found or auto page generation enabled. Generating HTML page from README.md..."
    generate_html_page
else
    log "If you wish to also have that cool HTML page, you can run the following command to generate a neat webpage for your GitHub project: ./_extra_bonus.py"
fi

update_github_about
""")
        print("Updated main script.")
    except Exception as e:
        print(f"Failed to update main script: {e}")

# Main function to execute all updates
def main():
    fix_permissions()
    set_git_config()
    add_alias('g', main_script, bashrc_file)
    create_update_github_about_script()
    update_main_script()
    source_bashrc(bashrc_file)
    print("All updates have been applied successfully.")

if __name__ == "__main__":
    main()
