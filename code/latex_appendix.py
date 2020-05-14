import numpy as np
import glob
import sys
import os


def sortedWalk(top, topdown=True, onerror=None):
    from os.path import join, isdir, islink

    names = os.listdir(top)
    names.sort()
    dirs, nondirs = [], []

    for name in names:
        if isdir(os.path.join(top, name)):
            dirs.append(name)
        else:
            nondirs.append(name)

    if topdown:
        yield top, dirs, nondirs
    for name in dirs:
        path = join(top, name)
        if not os.path.islink(path):
            for x in sortedWalk(path, topdown, onerror):
                yield x
    if not topdown:
        yield top, dirs, nondirs


f = open("code_appendix.tex", "w")

for subdir, dirs, files in sortedWalk('src'):
    subdir = subdir.split('/', 1)[-1]
    f.write("\\section{{{}}}\n".format(subdir))

    # print(files)
    files.sort()
    # print(files)

    for file in files:
        ext = os.path.splitext(file)[-1]

        pref = ''
        if file in ['_ROFL_with_jacobi.py']:
            pref = '%'

        if ext == '.cpp':
            lang = 'c++'
        elif ext == '.py':
            lang = 'python'
        else:
            continue

        caption = os.path.join(subdir, file).replace("_", "\_")

        f.write(pref +
                "\lstinputlisting[language={}, caption=src/{}]{{code/src/{}}}\n"
                .format(lang, caption, os.path.join(subdir, file)))

        # print(subdir, file, caption)
