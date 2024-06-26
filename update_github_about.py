import os
import subprocess
import requests

def get_git_config(key):
    try:
        return subprocess.check_output(['git', 'config', '--get', key]).decode('utf-8').strip()
    except subprocess.CalledProcessError:
        print(f"Error retrieving Git configuration for {key}. Ensure Git is configured properly.")
        return None

def read_kigit_config():
    config_file = "kigit.txt"
    tags = ""
    description = ""
    website = ""

    if os.path.exists(config_file):
        with open(config_file, 'r') as file:
            for line in file:
                if line.startswith("#"):
                    continue
                if "=" in line:
                    key, value = line.strip().split("=", 1)
                    key = key.strip()
                    value = value.strip()
                    if key == "tags":
                        tags = value
                    elif key == "description":
                        description = value
                    elif key == "website URL":
                        website = value
    return tags, description, website

def update_github_about(repo_name, token, tags, description, website):
    url = f'https://api.github.com/repos/{repo_name}'
    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    # Create data payload
    data = {
        'description': description,
        'homepage': website,
        'topics': [tag.strip() for tag in tags.split(',')]
    }

    # Update the repository details
    response = requests.patch(url, headers=headers, json=data)
    if response.status_code == 200:
        print("Repository 'About' section updated successfully.")
    else:
        print(f"Failed to update repository 'About' section: {response.status_code} {response.text}")

def main():
    user = get_git_config('github.user')
    repo_url = get_git_config('remote.origin.url')
    repo_name = repo_url.split('/')[-1].replace('.git', '') if repo_url else None
    if not repo_name:
        print("Repository name could not be determined.")
        return

    token_file = os.path.expanduser("~/.git_very_secret_and_ignored_file_token")
    if os.path.exists(token_file):
        with open(token_file, 'r') as file:
            github_token = file.read().strip()
    else:
        print("GitHub token not found. Please set it in your environment variables or save it in the specified file.")
        return

    tags, description, website = read_kigit_config()
    update_github_about(f"{user}/{repo_name}", github_token, tags, description, website)

    # Set up GitHub Pages
    headers = {
        'Authorization': f'token {github_token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    pages_url = f'https://api.github.com/repos/{user}/{repo_name}/pages'
    response = requests.get(pages_url, headers=headers)
    if response.status_code == 404:
        data = {
            'source': {'branch': 'master', 'path': '/'}
        }
        response = requests.post(pages_url, headers=headers, json=data)
        if response.status_code == 201:
            print("GitHub Pages has been set up.")
        else:
            print(f"Failed to set up GitHub Pages: {response.status_code} {response.text}")
    else:
        print("GitHub Pages is already set up.")

if __name__ == "__main__":
    main()
