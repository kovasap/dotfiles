import sys
from os.path import expanduser, getsize

def read_write_hist(infile: str, outfile: str):
    unique_cmds = set()
    filtered = []
    with open(infile, 'r') as f:
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
    with open(outfile, 'w') as f:
        f.writelines(filtered)

if __name__ == '__main__':
    hist_fname = expanduser('~/.bash_history')
    if len(sys.argv) == 2:
        backup_fname = expanduser(sys.argv[1])
        backup_size = getsize(backup_fname)
        hist_size = getsize(hist_fname)
        if backup_size > hist_size:
            raise Exception(
                f'Attempting to overwrite backup file {backup_fname}, which is '
                'larger than the current history!')
    else:
        backup_fname = hist_fname

    read_write_hist(hist_fname, backup_fname)
