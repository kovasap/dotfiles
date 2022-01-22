import copy
import subprocess

import config as c


def cmd_args_to_str(cmd_args):
  if isinstance(cmd_args, str):
    return cmd_args
  elif isinstance(cmd_args, list):
    return ' '.join(cmd_args)
  elif hasattr(cmd_args, '__name__'):
    return cmd_args.__name__
  else:
    return str(cmd_args)


def add_qtile_items(items):
  """Adds items from qtile config to xmenu items dictionary."""
  items = copy.deepcopy(items)
  for k in c.keys:
    description = f'{"-".join(k.modifiers)}-{k.key}'
    command = ''
    category = 'QTile'
    for cmd in k.commands:
      cmd_str = " ".join([cmd_args_to_str(a) for a in cmd.args])
      if hasattr(cmd, '_call'):
        description += f' {cmd._call._name}'
        if cmd._call._name == 'spawn':
          command += f'{cmd_str};'
          category = 'Commands'
      description += f' {cmd_str}'
    items[category].append(f'{description}\t{command}')
  return items


def make_xmenu_input_str(items):
  xmenu_input = '\n'
  for category, entries in items.items():
    xmenu_input += f'{category}\n'
    for entry in entries:
      xmenu_input += f'\t{entry}\n'
  return xmenu_input


all_items = {
    'Applications': [
        'Google Chrome\tgoogle-chrome',
        'Terminal (kitty)\tkitty',
    ],
    'Commands': [],
    'QTile': [
        'Logs\tkitty zsh -c "nvim ~/.local/share/qtile/qtile.log;read"'
    ],
    '': [],  # Horizontal bar.
    'Shutdown\tpoweroff': [],
    'Reboot\treboot': [],
}
all_items = add_qtile_items(all_items)
xmenu_input_str = make_xmenu_input_str(all_items)

subprocess.run('xmenu <<EOF | sh &' + xmenu_input_str + 'EOF', shell=True)
