#!/usr/bin/env python
"""fig repository information for use in a shell prompt

Adapted from experimental/users/mathewk/fig-prompt/fig_prompt.py by Mat King.
"""

from __future__ import with_statement

from mercurial import cmdutil
from mercurial import registrar
from mercurial import scmutil
import re

cmdtable = {}
command = registrar.command(cmdtable)

DEFAULT_SYMBOLS = {
    b'modified_str': '*'.encode(),
    b'added_str': '+'.encode(),
    b'deleted_str': '-'.encode(),
    b'unknown_str': '?'.encode(),
    b'unexported_str': '#'.encode(),
    b'obsolete_str': '&'.encode(),
}


@command(b'figstatus', [], b'hg figstatus')
def figstatus(ui, repo, fs=b'', **opts):
  """ Outputs the status of the current Fig repository as follows

  0:  File modified locally (*).
  1:  File added locally (+).
  2:  File removed locally (-).
  3:  Local file with unknown status (?).
  4:  Changes not exported to P4 (#).
  5:  Local revision is obsolete (&).
  6:  CL tag of associated CL.
  7:  CL description.
  8:  Branch name.
  9:  Revision number.
  10: Node id.
  11: Bookmarks.
  12: CL name (as per hg cls-name).
  13: Shortest unique hex revision.
  """

  def print_if(symbol, condition):
    if condition:
      ui.write(symbol)
    ui.write(b'\n')

  working = repo[b'.']
  clrevs = repo.revs(b'exported(.)')

  head = working.rev() == repo.revs(b'p4head').first()

  exported_rev = repo[list(clrevs)[0]] if clrevs else b''
  names = repo.names[b'pendingcls'].names(repo, repo[b'.'].node())
  cl_num = ([x[len(b'cl/'):] for x in names if x.startswith(b'cl/')] or
            [b''])[0]

  non_numerical_names = [x for x in names if not x.startswith(b'cl/')]
  non_numerical_names.sort(key=lambda x: x.startswith(b'change-'))
  cl_name = non_numerical_names[0] if non_numerical_names else b''

  status = repo.status(unknown=True)

  revs = scmutil.revrange(repo, [b'.'])
  allrevs = repo.revs(b'only(%ld, p4head)', revs)

  actual_symbols = {
      k: ui.config(b'figstatus', k, v) for k, v in DEFAULT_SYMBOLS.items()
  }
  print_if(actual_symbols[b'modified_str'], any(status.modified))
  print_if(actual_symbols[b'added_str'], any(status.added))
  print_if(actual_symbols[b'deleted_str'], any(status.removed))
  print_if(actual_symbols[b'unknown_str'], any(status.unknown))

  if any(clrevs):
    print_if(actual_symbols[b'unexported_str'], exported_rev != working)
    print_if(actual_symbols[b'obsolete_str'], working.obsolete())
    ui.write(cl_num + b'\n')
  else:
    ui.write(b'\n\n\n')

  if head:
    ui.write(b'p4head\n')
  else:
    description_first_line = cmdutil.rendertemplate(working,
                                                    b'{GOOG_trim_desc(desc)}')
    ui.write(description_first_line + b'\n')

  # branch name
  m = re.search(b'FIG_BRANCH_NAME=(.*)', working.description())
  m_fallback = re.search(br'^\[([^]]*)\]', working.description())
  if head:
    ui.write(b'p4head\n')
  elif m:
    ui.write(m.group(1) + b'\n')
  elif m_fallback:
    ui.write(m_fallback.group(1) + b'\n')
  else:
    ui.write(cl_num + b'\n')

  # rev number
  ui.write(b'%d\n' % working.rev())
  # node long id
  ui.write(working.hex() + b'\n')
  # comma separated bookmarks
  ui.write(b', '.join(working.bookmarks()) + b'\n')
  # CL name
  ui.write(cl_name + b'\n')
  # shortest id
  ui.write(scmutil.shortesthexnodeidprefix(repo, working.node()) + b'\n')
