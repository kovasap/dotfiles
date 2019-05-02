from os.path import expanduser

unique_cmds = set()
filtered = []
hist_fname = expanduser('~/.bash_history')
with open(hist_fname, 'r') as f:
    it = iter(f)
    for row in it:
        num, cmd = row, next(it)
        if cmd not in unique_cmds:
            unique_cmds.add(cmd)
            filtered.append(num)
            filtered.append(cmd)

with open(hist_fname, 'w') as f:
    f.writelines(filtered)
