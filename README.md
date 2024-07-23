# Auto Git Unicorn Moose Feather Light Windmill of MTLMBSM 🦄💨
![Git Unicorn Moose Feather Light Windmill](auto_git_unicorn_moose_feather_light_windmill.webp)

**What is MTLMBSM? 🤔**
MTLMBSM stands for "Meh To Less Meh But Still Meh," a humorous way to describe how this script simplifies and automates aspects of version control and GitHub interactions. If you're not smiling yet, this script might not be for you 😆!

**Features 🎉**

* **Config File Handling:** Creates, updates, and validates the `kigit.txt` file for all interactions, ensuring smooth operation 😊.
* **Error Handling:** Centralized error handling mechanism that continues execution despite errors 🙅‍♂️.
* **Modular Design:** The script is organized into distinct functions for better maintainability and readability 🎂.
* **Repository Initialization:** Initializes a Git repository if not already present 🌱.
* **.gitignore Creation:** Generates a `.gitignore` file with common patterns and sensitive file protections 🔒.
* **README.md Setup:** Automatically sets up or updates a `README.md` with a description, tags, and other relevant details 📄.
* **.bashrc Update:** Optionally updates `.bashrc` to include an alias for easy script execution ⏱️.
* **HTML Page Generation:** Creates an HTML page from the `README.md` if specified in the configuration 📊.
* **GitHub Repository Management:** Creates or updates the GitHub repository based on `kigit.txt`, including setting descriptions, website, and topics 💻.
* **Branch and Repo Handling:** Creates new branches or repositories if specified names do not exist 🆕.
* **Automation:** Syncs changes and updates GitHub pages as needed 🤖.
* **Interactive Setup:** If `kigit.txt` is missing, the script creates a standard configuration file and halts for user review before proceeding 🛑.

**Setup 🎉**
1. Download the script to your preferred directory.
2. Make it executable with `chmod +x`.
3. Run it from your terminal.

### Adding to .bashrc
To add an alias for easy script execution:
1. Run the script.
2. Follow the interactive prompts to add the alias to your `.bashrc`.

### Automated Commit and Push
For automating commits and pushes, use the `auto_commit_push.sh` script. This script can be set up as a cron job to run periodically. For example, to run the script daily at 4:42 PM, add the following line to your crontab (`crontab -e`): `42 16 * * * /path/to/auto_commit_push.sh "Auto-commit"`

**Configuration File Handling**
- **`kigit.txt`**: The script creates or updates `kigit.txt` with repository settings, including repo name, branch, description, and tags. The script checks for the presence of `kigit.txt` and prompts the user to edit and rerun if not present.
- **Force Updates**: Use `force:` in `kigit.txt` to overwrite existing repository settings or files.

**Further Improvements 🚀**
The script is designed to be flexible and forgiving. If you have suggestions for improvements or new features, please just do your thing. 

**Contribution Guidelines 📝**
To contribute:
1. Fork the repository and create a new branch for your changes.
2. Make your changes and commit them with a descriptive message.
3. Submit a pull request for review.

**License 📜**
This project is licensed under the MIT License.