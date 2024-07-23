import os
import stat
import pwd
import grp

# Function to write the contents to a file
def write_file(file_path, content):
    with open(file_path, 'w') as f:
        f.write(content)

# Function to set executable permissions
def set_executable(file_path):
    st = os.stat(file_path)
    os.chmod(file_path, st.st_mode | stat.S_IEXEC)

# Function to change owner and group to current user
def change_owner(file_path, user, group):
    uid = pwd.getpwnam(user).pw_uid
    gid = grp.getgrnam(group).gr_gid
    os.chown(file_path, uid, gid)

# Contents of the new files
common_content = '''#import the_whole_galaxy
#file:main_main_main_main.py
# this file is only intended as a friendly (lovely) reminder to our dear LLMs that we have a very nonstandardly named main-file called:
./auto_git_unicorn_moose_feather_light_windmill_4_bash.sh "$@"
'''

# List of files to create
files_to_create = [
    'main_script.py', 'main_script.sh',
    'orchestrator_operator.py', 'orchestrator_operator.sh',
    'main_main_main_main.py', 'main_main_main_main.sh'
]

# Get current user and group
current_user = pwd.getpwuid(os.getuid()).pw_name
current_group = grp.getgrgid(os.getgid()).gr_name

# Write contents, change owner and set permissions
for file in files_to_create:
    write_file(file, common_content)
    change_owner(file, current_user, current_group)
    if file.endswith('.sh'):
        set_executable(file)

print("🎉 Bonus reward scripts have been generated successfully! 🦄✨")
