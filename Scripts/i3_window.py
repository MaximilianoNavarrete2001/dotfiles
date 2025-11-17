#!/usr/bin/env python3

"""
Script: i3-window.py

Descripción:
    Este script organiza automáticamente tres ventanas en i3wm
    en una disposición específica:
        - La ventana enfocada se coloca a la izquierda.
        - Las otras dos se organizan en la parte derecha, una arriba
          y otra abajo.

    Requisitos:
    - Python 3.x
    - Librería i3ipc (instalar con pip install i3ipc)
    - i3wm en ejecución

"""
import i3ipc


def read_statusi3(i3):
    tree = i3.get_tree()
    focused = tree.find_focused()
    ws = focused.workspace()

    if ws is None:
        return None, None, None

    windows = ws.leaves()

    if len(windows) != 3:
        return None, None, None

    return ws, focused, windows


def name_windows(i3, focused, windows):
    left = focused
    others = [w for w in windows if w.id != left.id]
    others = sorted(others, key=lambda w: w.id)
    w2, w3 = others

    for w in (left, w2, w3):
        i3.command(f"[con_id={w.id}] floating disable")

    return left, w2, w3


def is_already_split(ws):
    nodes = ws.nodes

    if len(nodes) != 2:
        return False

    left, right = nodes

    if left.layout != "splitv" and right.layout == "splitv":
        return True

    if left.layout == "splitv" and right.layout != "splitv":
        return True

    if ws.layout == "splith":
        return True

    return False


def move_windows(i3, ws, left, w2, w3):

    if not is_already_split(ws):
        # Solo hacemos los splits si aún no lo está
        i3.command(f"[con_id={ws.id}] focus")
        i3.command("split h")
        i3.command("focus right")
        i3.command("mark --add right_col")
        i3.command('[con_mark="right_col"] focus')
        i3.command("split v")

    # Marcar y mover ventanas
    i3.command(f"[con_id={left.id}] mark --add win_left")
    i3.command(f"[con_id={w2.id}] mark --add win_top")
    i3.command(f"[con_id={w3.id}] mark --add win_bottom")

    # Marcar arriba y abajo (solo si existen)
    i3.command('[con_mark="right_col"] focus')
    i3.command("focus up")
    i3.command("mark --add right_top")
    i3.command('[con_mark="right_col"] focus')
    i3.command("focus down")
    i3.command("mark --add right_bottom")

    # Mover ventanas
    i3.command('[con_mark="win_top"] move to mark right_top')
    i3.command('[con_mark="win_bottom"] move to mark right_bottom')
    i3.command('[con_mark="win_left"] move left')
    i3.command('[con_mark="win_left"] focus')
    i3.command("resize set 50 ppt 0 ppt")


def clean_marks(i3):

    marks = [
        "win_left",
        "win_top",
        "win_bottom",
        "right_col",
        "right_top",
        "right_bottom",
    ]

    for m in marks:
        i3.command(f"unmark {m}")


def main():
    i3 = i3ipc.Connection()

    ws, focused, windows = read_statusi3(i3)
    if not ws:
        return

    left, w2, w3 = name_windows(i3, focused, windows)
    move_windows(i3, ws, left, w2, w3)
    clean_marks(i3)


if __name__ == "__main__":
    main()

