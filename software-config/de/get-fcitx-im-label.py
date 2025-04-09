import os
import re

def get_label(im_name):
    if im_name.startswith('keyboard'):
        # Special
        with open(os.path.expanduser("~/.config/fcitx5/conf/cached_layouts"), mode='r', encoding='utf-8') as f:
            data = f.read()
            match = re.search(r'\[' + im_name + r'\]\n(?:.+\n)+Label=(.+)', data)
            if match:
                return match.group(1)

    fcitx5_path = None
    for i in os.environ['PATH'].split(':'):
        p = os.path.join(i, 'fcitx5')
        if os.path.exists(p):
            fcitx5_path = p

    if not fcitx5_path:
        raise Exception('fcitx5 not found')

    while os.path.islink(fcitx5_path):
        fcitx5_path = os.readlink(fcitx5_path)

    fcitx5_dirname = os.path.dirname(fcitx5_path)
    fcitx5_im_dir = os.path.join(fcitx5_dirname, '../share/fcitx5/inputmethod')
    fcitx5_im_path = os.path.join(fcitx5_im_dir, f'{im_name}.conf')

    with open(fcitx5_im_path, mode='r', encoding='utf-8') as f:
        for i in f.readlines():
            match = re.match(r'^Label=(.+)$', i)
            if match:
                return match.group(1)
                break

with os.popen('fcitx5-remote -n') as f:
    name = f.read().strip()
    print(get_label(name))
