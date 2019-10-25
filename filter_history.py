import sys
import re
from os.path import expanduser, getsize

timestamp_re = re.compile('^#\d*$')

def test_timestamp_re():
    assert timestamp_re.match('#000')
    assert not timestamp_re.match('bash')
    assert not timestamp_re.match('#bash')
    assert timestamp_re.match('#1324018257012985')
    assert not timestamp_re.match('1324018257012985')
    print('tests passed!')

def read_write_hist(infile: str, outfile: str):
    unique_cmds = set()
    filtered = []
    with open(infile, 'r') as f:
        cur_timestamp = ''
        for line in f:
            if timestamp_re.match(line):
                # this is a timestamp
                cur_timestamp = line
            else:
                if line not in unique_cmds:
                    unique_cmds.add(line)
                    filtered.append(cur_timestamp)
                    filtered.append(line)
    with open(outfile, 'w') as f:
        f.writelines(filtered)

if __name__ == '__main__':
    # test_timestamp_re()
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
