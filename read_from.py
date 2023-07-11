#!/usr/bin/env python
#  Copyright (C) 2023 Roderik Ploszek
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
