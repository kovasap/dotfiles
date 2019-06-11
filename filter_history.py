import sys
from os.path import expanduser

def read_write_hist(outfile: str=None):
    unique_cmds = set()
    filtered = []
    hist_fname = expanduser('~/.bash_history')
    with open(hist_fname, 'r') as f:
        it = iter(f)
        for row in it:
            try:
                num, cmd = row, next(it)
            except:
                print(row)
                raise
            if cmd not in unique_cmds:
                unique_cmds.add(cmd)
                filtered.append(num)
                filtered.append(cmd)

    with open(outfile if outfile is not None else hist_fname, 'w') as f:
        f.writelines(filtered)

if __name__ == '__main__':
    read_write_hist(sys.argv[1] if len(sys.argv) == 2 else None)
