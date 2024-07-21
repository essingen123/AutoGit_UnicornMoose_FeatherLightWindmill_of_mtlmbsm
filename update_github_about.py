import os
import subprocess
import requests
import sys

# file: update_github_about.py

verbose = "y"

def log(message):
    if verbose == "y":
        print(message)

def install_requirements():
    """Install necessary Python packages."""
    try:
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'markdown', 'requests'])
    except subprocess.CalledProcessError:
        log("Failed to install required Python packages.")
        return False
    return True

def convert_readme_to_html():
    """Convert README.md to HTML."""
    if os.path.exists("README.md"):
        import markdown
        with open("README.md", 'r') as readme_file:
            readme_content = readme_file.read()
        html = markdown.markdown(readme_content)
        return html
    else:
        log("README.md not found.")
        return None

def generate_additional_html():
    """Generate additional HTML content."""
    additional_html = """
    <script>
    function toggleVisibility(id) {
        var element = document.getElementById(id);
        if (element.style.display === 'none') {
            element.style.display = 'block';
        } else {
            element.style.display = 'none';
        }
    }
    </script>
    <h2 onclick="toggleVisibility('contrib')">Contribution Guidelines</h2>
    <div id="contrib" style="display:none;">
        <p>Here are some basic guidelines for contributing to this project.</p>
    </div>
    """
    return additional_html

def check_github_pages(repo_name, token):
    """Check if GitHub Pages is set up for the repository."""
    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    response = requests.get(f'https://api.github.com/repos/{repo_name}/pages', headers=headers)
    if response.status_code == 404:
        setup_github_pages(repo_name, token)

def setup_github_pages(user, repo_name, token):
    """Set up GitHub Pages for the repository."""
    headers = {
        'Authorization': f'token {token}',
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
            log("GitHub Pages has been set up.")
        else:
            log(f"Failed to set up GitHub Pages: {response.status_code} {response.text}")
    else:
        log("GitHub Pages is already set up.")

def create_html_page():
    """Create an HTML page from README.md."""
    readme_html = convert_readme_to_html()
    if readme_html:
        additional_html = generate_additional_html()
        full_html = f"<html><head><title>Repository Info</title></head><body>{readme_html}{additional_html}</body></html>"
        with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'index.html'), 'w') as html_file:
            html_file.write(full_html)
        log("index.html created successfully.")
    else:
        log("Failed to create index.html.")

def get_git_config(key):
    try:
        return subprocess.check_output(['git', 'config', '--get', key]).decode('utf-8').strip()
    except subprocess.CalledProcessError:
        log(f"Error retrieving Git configuration for {key}. Ensure Git is configured properly.")
        return None

def read_kigit_config():
    """Read the kigit.txt configuration file for tags, description, and website URL."""
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
    """Update the GitHub repository's About section with description, homepage, and topics."""
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
        log("Repository 'About' section updated successfully.")
    else:
        log(f"Failed to update repository 'About' section: {response.status_code} {response.text}")

def main():
    """Main function to generate HTML page and check GitHub Pages setup."""
    # Ensure required packages are installed
    if not install_requirements():
        return

    user = get_git_config('user.name')
    repo_url = get_git_config('remote.origin.url')
    repo_name = repo_url.split('/')[-1].replace('.git', '') if repo_url else None

    log(f"User: {user}")
    log(f"Repo URL: {repo_url}")
    log(f"Repo Name: {repo_name}")

    if not repo_name:
        log("Repository name could not be determined.")
        return

    token_file = os.path.expanduser("~/.git_very_secret_and_ignored_file_token")
    if os.path.exists(token_file):
        with open(token_file, 'r') as file:
            github_token = file.read().strip()
    else:
        log("GitHub token not found. Please set it in your environment variables or save it in the specified file.")
        return

    tags, description, website = read_kigit_config()

    update_github_about(f"{user}/{repo_name}", github_token, tags, description, website)
    setup_github_pages(user, repo_name, github_token)

if __name__ == "__main__":
    verbose = os.getenv("VERBOSE", "y").lower() == "y"
    main()
