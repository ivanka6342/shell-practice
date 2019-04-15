#!/home/vaka/.pyenv/shims/python3

import sys

length = int(sys.argv[1])

if length < 0:
    print("py_f: %d is incorrect argument\n" % length)
    sys.exit(-1)

string = "".zfill(length)

i = 0
el = 1
step = 2

while i < length:
    string = string[:i] + el.__str__() + string[i+1:]
    i += step
    step += 1
    el += 1

print ("f(%d) -> \"%s\"\n" % (length, string))