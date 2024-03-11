# template-cpp-msvc-vscode
Template for C++ root folder for projects using the MSVC compiler in VSCode (in Windows)

> **NOTE**:  *This template setup contains kind of a lot of caveats; so you might just want to install and use a full version of Visual Studio for your C++ development instead of VSCode.*

# Disclaimer
Please see the MIT license in this repository root.  I'm putting this out there AS-IS, with no inference/intent/assurance/offer of any kind of warranty.  This seems to work for me.  I hope it works for you.

USE ACTUAL VISUAL STUDIO if you want good assurance that your C++ programming experience is going to be good.  But if you're like me and are already using Visual Studio Code, happy to keep things that way, and you're looking for something light-weight which _seems_ to be just fine, you're in the right place. :)


# Details
I wrote this in a Windows 11 environment, but _which version_ of Windows shouldn't really matter.

This expects that you have the C++ Extension for Visual Studio Code installed, following [this document (link)]](https://code.visualstudio.com/docs/languages/cpp).
**This repo set-up** is valid for the [MSVC](https://code.visualstudio.com/docs/cpp/config-msvc#_prerequisites) compiler.

## Environment Requirements

### For VSCode tooling
* Windows OS (11 tested)
* Microsoft Visual Studio Code (v1.81.1 User Setup tested)
* MSVC installed
* C++ Extension installed
* Visual Studio Code running, having been started from within Microsoft Developer Command Prompt

### For commandline tooling
* Powershell 7.4.1+ (7.4.1 tested from within VSCode opened by Microsoft Developer Command Prompt)
* Microsoft Developer Command Prompt ()

## What need does this serve?

Out of the box (following the linked tutorials above), the C++ setup in code with MSVC makes it possible for you (with the .vscode folder and associated/contained json files) to run and debug SINGLE-FILE programs in the folder tree containing the .vscode folder.  It doesn't give you:
* easy use of multiple files (kinda quick change within the tasks.json file)
* easy use of a folder structure within your project
* hands-off support for multiple projects with different folder structure

The kinds of things which full-blown Visual Studio gives you in its project and solution files for some reason aren't currently available in VSCode; or at least I didn't find an analog.
So this template gives you the ability to have:
* multiple different projects without needing a configuration for each one
* single-file projects
* multiple-file projects
* projects containing a folder structure and multiple files within
* projects with differing folder structures without needing to change the configuration files

## Setup

The structure of this folder tree looks like this:

**Root**
* .vscode/
    * tasks.json
* projects/
    * ...your project root folders
* .gitignore
* rebuild_all.bat
* clean_all.ps1
* build_all.ps1

The .bat and .ps1 files at the root are supplementary, and not necessary for this template to be useful to you if you're only operating within VSCode.  They assume that you're using `main.cpp` as your main file in each project (see more below).

For operation within VSCode, this template tooling (in the `/.vscode/tasks.json` file) makes use of the following folders within projects when you run/debug them:
1. `__temp` - where your source is copied in order to build
2. `__bin` - where the .obj, .pdb, and .exe files get written

# Usage

## Within VSCode
Focus your project's main cpp file (doesn't matter what its name is) in the editor and start it running/debugging (F5 or the play/debug buttons in the UI), and the tooling will:
1. Remove the entire `__bin` folder, and any content within the `__temp` folder, if one exists.
2. Create the `__temp` folder, if it doesn't exist.
3. Copy any `.h` or `.cpp` folder within your project tree (except those within `__temp`) into the `__temp` folder.  Because this flattens the file structure out within `__temp`, this does mean that your project should _not_ contain any duplicate file names.
4. Change working directory to `__bin` and execute `cl.exe` on the source files within `__temp`, producing the `{project folder name}.exe` file within `__bin`. 

***It just occurred to me that this copying mechanism and build tooling will almost certainly fall-over if you include `.h` files which exist outside of the immediate folder of the file referencing them**.  It has been a long time since I've done any C++ programming. 

## From the commandline
> **Note:**  
>
> Commandline will only work in either:  Microsoft Developer Command Prompt   or   Powershell (7 or 5) started from Microsoft Developer Command Prompt   or   A pwsh terminal window in VSCode, launched from Microsoft Developer Command Prompt.  
> See information below the rebuild examples for setting up a file for starting VSCode within Microsoft Developer Command Prompt.
>
> You may also need to set your script execution policy in order to get the commandline functionality to work

One thing that the VSCode tooling I've got in there doesn't do well (because I'm not very experienced with the VSCode tasking) is cleaning the projects up between builds.  I set the working directories up to in order to keep from generated files { `.obj`, `.pdb`, `.exe` } out of the source.  This helps, but if you're doing like I am and are source controlling in github, you'll want to have that stuff deleted.  OBVIOUSLY the .gitignore file will keep you from accidentally source controlling non-source files, but maybe you want to keep things tidy anyway -- save your drive space and everything.

### clean_all.ps1
For quickly disposing of all generated files, I've created the `clean_all.ps1` script. Running that will erase all of the `__temp`, `__bin`, and `__export` folders out of the folder tree.

### build_all.ps1
Say you'd like to build all of your projects at one go?  It's `build_all.ps1` to the rescue!  This will operate across all projects which contain a `main.cpp` at the root level of folders within `/projects/`, and will run the equivalents of what's done through the VSCode UI.  There are three differences, though:
1. There is no debugging via the commandline; it's just a build.
2. By default, the commandline build doesn't generate `.pdb` files
3. By default, the commandline build will copy your `.exe` files from `__bin` to `__export`

`build_all.ps1` takes two parameters, in this order:
1. build configuration (`release` unless specified as exactly `debug`) - this controls whether or not `.pdb` files are created by the build.
2. do export (true unless specified as `0`)

**EXAMPLE:** `build_all.ps1 debug 0` -- this will build `.pdb` files along with the `.obj` and `.exe` files, in the `__bin` folders, but will _not_ create the `__export` folder or copy `.exe` into them.

**EXAMPLE:** `build_all.ps1 0 0` -- will not build `.pdb` files, and will not export the `.exe`
**EXAMPLE:** `build_all.ps1 anything_here_but_0 0` -- will not build `.pdb` files, and will not export the `.exe`

**EXAMPLE:** `build_all.ps1 anything_here_but_debug anything_here_but_0` -- will not build `.pdb` files, but ***will*** export the `.exe` to the `__export` folders.

### rebuild_all.bat
*If you are running the commands from powershell or a terminal in VSCode* this file is redundant.  If you're just running the Microsoft Developer Command Prompt only, this batch file is important.

This works almost just like `build_all.ps1` except it runs `clean_all.ps1` first.  The `clean_all.ps1` invocation's actually redundant, since `build_all.ps1` cleans during the project-by-project build, anyway; I made the `.bat` file before I'd finished the `build_all.ps1` and at the time, the build wasn't cleaning first. 

The `rebuild_all.bat` file takes the same two parameters in the same order as `build_all.ps1`, and so the examples here would be superfluous, since they're the same as the ones for `build_all.ps1`.


## A 1-click file for opening VSCode within Microsoft Developer Command Prompt
Do you want to start a Microsoft Developer Command Prompt, then type inside it to start VSCode for this?  No.  You don't.  So to get this functionality in a single-click (unfortunately, not in context menus or anything), you can make yourself a batch file, and then pin a shortcut to your Windows taskbar.  The file contents would be something like this:
```
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat"

code <PATH_YOU_WOULD_WANT_TO_OPEN_AS_VSCODE_WORKSPACE_ROOT_HERE>
```

# Example Projects

**EXTRA SIMPLE** project examples are available for the few use cases I thought of and quickly tested, but you'll notice I didn't write anything using `.h` files. I can't really say for sure they'll work, *especially* if the includes cross folder boundaries.