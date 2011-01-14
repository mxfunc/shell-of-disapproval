#!/usr/bin/env python

# theoretically allow it to work on multiple operating systems
import os
UNAME = os.uname()[0]

# theoretically allow the user to choose different images at compile time
IMAGE = "disapproval.png"

# blah blah blah
APPNAME = 'disapprove'
VERSION = '1.0'

def options(opt):
  opt.tool_options('compiler_c c')

def configure(conf):
  conf.check_tool('compiler_c c')

files = {
  "Darwin": ["MacOSX/shell-of-disapproval.m"]
}[UNAME]

def build(bld):
  # compile obj-c
  from waflib import TaskGen
  TaskGen.task_gen.mappings['.m'] = TaskGen.task_gen.mappings['.c']
  
  # this is a program i suppose
  disapprove = bld.program(source = " ".join(files),
                           features = "c cprogram",
                           name = "disapprove",
                           target = "disapprove")
  
  if UNAME == "Darwin":
    path = os.path.join(bld.env["PREFIX"], "share",
                        "shell-of-disappoval", IMAGE)
    disapprove.cflags = ['-DIMAGE_FILE=@"{0}"'.format(path)]
    disapprove.framework = 'Cocoa'
  
  # install the LOD image
  bld.install_files("${PREFIX}/share/shell-of-disappoval",
                    "Images/disapproval.png")
  
  # write to ~/.zshrc
  func = """

# shell of disapproval goodness
[[ -f {0} ]] && function command_not_found_handler() {{
  echo "$1? ಠ_ಠ" &
  {0} &
}}""".format(os.path.join(bld.env["PREFIX"], "bin", "disapprove"))
  
  with open(os.path.expanduser("~/.zshrc"), "r") as zshrc:
    if func not in zshrc.read():
      with open(os.path.expanduser("~/.zshrc"), "a") as zshrc:
        zshrc.write(func)