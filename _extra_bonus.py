import os
import subprocess
import requests
import sys

def get_git_config(key):
    try:
        return subprocess.check_output(['git', 'config', '--get', key]).decode('utf-8').strip()
    except subprocess.CalledProcessError:
        print(f"Error retrieving Git configuration for {key}. Ensure Git is configured properly.")
        return None

def install_requirements():
    try:
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'markdown', 'requests'])
    except subprocess.CalledProcessError:
        print("Failed to install required Python packages.")
        return False
    return True

def convert_readme_to_html():
    if os.path.exists("README.md"):
        import markdown
        with open("README.md", 'r') as readme_file:
            readme_content = readme_file.read()
        html = markdown.markdown(readme_content)
        return html
    else:
        print("README.md not found.")
        return None

def generate_additional_html():
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
    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    response = requests.get(f'https://api.github.com/repos/{repo_name}/pages', headers=headers)
    if response.status_code == 404:
        setup_github_pages(repo_name, token)

def setup_github_pages(repo_name, token):
    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }
    data = {
        'source': {'branch': 'master', 'path': '/'}
    }
    response = requests.post(f'https://api.github.com/repos/{repo_name}/pages', headers=headers, json=data)
    if response.status_code == 201:
        print("GitHub Pages has been set up.")
    else:
        print("Failed to set up GitHub Pages.")

def create_html_page():
    readme_html = convert_readme_to_html()
    if readme_html:
        additional_html = generate_additional_html()
        full_html = f"<html><head><title>Repository Info</title></head><body>{readme_html}{additional_html}</body></html>"
        with open('index.html', 'w') as html_file:
            html_file.write(full_html)
        print("index.html created successfully.")
    else:
        print("Failed to create index.html.")

def main():
    # Ensure required packages are installed
    if not install_requirements():
        return

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

    create_html_page()
    check_github_pages(f"{user}/{repo_name}", github_token)

if __name__ == "__main__":
    main()
