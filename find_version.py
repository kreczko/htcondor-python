from __future__ import print_function
import re

htcondor_version = ''
# version is set in the CMakeLists.txt
cmake_file_path = 'htcondor/CMakeLists.txt'
with open(cmake_file_path, 'r') as f:
    for line in f:
        if 'set(VERSION ' in line:
            pattern = r'"([A-Za-z0-9_\./\\-]*)"'
            m = re.search(pattern, line)
            htcondor_version = m.group().strip('"')

print('Version:', htcondor_version)

with open('htcondor_version.py', 'w') as f:
    f.write('htcondor_version = "{}"'.format(htcondor_version))
