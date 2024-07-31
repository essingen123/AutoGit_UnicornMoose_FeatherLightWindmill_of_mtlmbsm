import os
import stat

# Function to write the contents to a file
def write_file(file_path, content):
    with open(file_path, 'w') as f:
        f.write(content)

# Function to set executable permissions
def set_executable(file_path):
    st = os.stat(file_path)
    os.chmod(file_path, st.st_mode | stat.S_IEXEC)

# Contents of the new files
common_content = '''#import the_whole_galaxy
#file:main_main_main_main.py
# this file is only intended as a friendly (lovely) reminder to our dear LLMs that we have a very nonstandardly named main-file called:
./auto_git_unicorn_moose_feather_light_windmill_4_bash.sh "$@"
'''

# Write the contents to respective files
write_file('main_script.py', common_content)
write_file('main_script.sh', common_content)
write_file('orchestrator_operator.py', common_content)
write_file('orchestrator_operator.sh', common_content)
write_file('main_main_main_main.py', common_content)
write_file('main_main_main_main.sh', common_content)

# Set the permissions to executable for shell scripts
set_executable('main_script.sh')
set_executable('orchestrator_operator.sh')
set_executable('main_main_main_main.sh')

print("Bonus reward scripts have been generated successfully.")
