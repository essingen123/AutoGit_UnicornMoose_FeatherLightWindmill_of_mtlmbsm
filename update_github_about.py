import os
import requests
import subprocess

def get_git_config(key):
    try:
        return subprocess.check_output(['git', 'config', '--get', key]).decode('utf-8').strip()
    except subprocess.CalledProcessError:
        print(f"Error retrieving Git configuration for {key}. Ensure Git is configured properly.")
        return None

def update_github_about(repo_name, token):
    url = f'https://api.github.com/repos/{repo_name}'
    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    # Prompt user for repository details
    description = input("Enter a description for the repository: ")
    website = input("Enter a website URL for the repository (leave blank if none): ")
    topics = input("Enter topics for the repository, separated by commas (e.g., python, automation): ").split(',')

    # Create data payload
    data = {
        'description': description,
        'homepage': website,
        'topics': [topic.strip() for topic in topics if topic.strip()]
    }

    # Update the repository details
    response = requests.patch(url, headers=headers, json=data)
    if response.status_code == 200:
        print("Repository 'About' section updated successfully.")
    else:
        print(f"Failed to update repository 'About' section: {response.status_code} {response.text}")

def main():
    user = get_git_config('user.name')
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

    update_github_about(f"{user}/{repo_name}", github_token)

if __name__ == "__main__":
    main()
