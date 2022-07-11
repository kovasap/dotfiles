# Vim Tricks

## Open File in GitHub

https://github.com/ruanyl/vim-gh-line

## Editing Over SSH

You can use your local machine's setup to edit remote files with `vim
scp://user@myserver[:port]//path/to/file.txt`.


## Search/Replace

See http://vimregex.com/#substitute for details.

### Convert protos to bzl dictionaries

Replace `text: text2` with `"text": text2,`:
```
:%s/\(\S.*[^"]\): \(.*\)$/"\1": \2,/g
```

Replace floating points number with quoted variants:
```
:%s/[^"]\(\d\+\)\.\(\d\+\)/"\1\.\2"/g
```

