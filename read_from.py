#!/usr/bin/env python
"""Usage: read_from.py <file> <file_match>

This program will print contents of `file` beginning *after* line that is equal
to contents of `file_match`.
"""
from sys import argv

# In which file to search the string
filepath = argv[1]
# File to which match
match = argv[2]

printing = False

with open(match) as f:
    match = f.read()

with open(filepath) as f:
    for l in f.readlines():
        if printing:
            print(l, end='')
            continue
        if l == match:
            printing = True
