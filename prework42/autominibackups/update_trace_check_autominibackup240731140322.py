import os

def update_bashrc_with_trace_check(script_path):
    bashrc_file = os.path.expanduser("~/.bashrc")
    alias_cmd = f"alias g='{script_path}'"
    
    trace_check_cmd = "if ! type g > /dev/null 2>&1; then\n"
    trace_check_cmd += f"    {alias_cmd}\n"
    trace_check_cmd += "    echo 'Alias g added to .bashrc. Please restart your terminal or source ~/.bashrc.'\n"
    trace_check_cmd += "fi\n"

    with open(bashrc_file, 'a') as f:
        f.write(trace_check_cmd)

    print("Updated .bashrc with alias trace check.")

def main():
    script_path = os.path.join(os.getcwd(), "auto_git_unicorn_moose_feather_light_windmill_4_bash.sh")
    update_bashrc_with_trace_check(script_path)

if __name__ == "__main__":
    main()
