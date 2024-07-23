# Auto Git Unicorn Moose Feather Light Windmill of MTLMBSM
![Auto Git Unicorn Moose Feather Light Windmill](auto_git_unicorn_moose_feather_light_windmill.webp)

This script automates the initial setup of a Git repository with enhanced interactive features, handling the creation of `.gitignore`, `README.md`, and GitHub repository setup based on user input.

## Definition of MTLMBSM
MTLMBSM stands for "Meh To Less Meh But Still Meh," humorously capturing the essence that while Git and this script have their weaknesses, they still simplify certain aspects of version control. (If you're not sensing at least a glimpse of a smile here, this script may not serve you as intended 😆)

## Features
- **Config File Handling**: Creates and Loosely validates the `kigit.txt` file for all interaction to run in automation, ensuring ease of use and default settings.
- **Error Handling**: Implements a centralized error handling mechanism for consistent error management.
- **Modular Design**: Breaks down the script into independent chunks, focusing on separate tasks for better maintainability.
- **Initialization**: Initializes a Git repository if not already initialized.
- **.gitignore Creation**: Creates a `.gitignore` with common ignore patterns and sensitive file protection.
- **README.md Setup**: Interactively sets up a `README.md` with a simple description.
- **.bashrc Update**: Optionally updates `.bashrc` to include an alias for easy script execution.
- **HTML Page Generation**: Generates an HTML page from `README.md`.
- **GitHub Repository Setup**: Updates the "About" section of the GitHub repository with description, website, and topics.
- **Automation**: Automates commits and pushes using a cron job setup.
- **Selective Branch Management**: Allows specifying a branch for commits in the `kigit.txt` file.

## Setup
To use this script, simply download it to your preferred directory, make it executable with `chmod +x`, and run it from your terminal.

### Adding to .bashrc
The script can add an alias to your `.bashrc` for easy access. Just run the script and follow the interactive prompts.

### Automated Commit and Push
To automate commits and pushes, you can use the `auto_commit_push.sh` script and set it up as a cron job. Here is an example of how to add a cron job:

# Run the script every day at 4:42 pm
42 16 * * * g "Auto-commit"

## Further Improvements
This script is constantly improving. If you have any suggestions or contributions, please see our [Contribution Guidelines](CONTRIBUTING.md).

## Contribution Guidelines
If you'd like to contribute to this project, please follow these guidelines:

* Fork the repository and create a new branch for your changes.
* Make your changes and commit them with a descriptive commit message.
* Create a pull request and wait for review.

## License
This project is licensed under the MIT License.
