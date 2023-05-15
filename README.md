# ValaOnWindows


# Install msys2

Download and install msys2 from https://www.msys2.org/

Msys2 is a unix-like environment for Windows. It provides a shell, pacman package manager, and other tools commonly found in a unix environment.

The installer will install multiple environments for different compilers. We will use the MSYS2 MINGW64 environment. 

# Install Vala

Open the MINGW64 shell from the start menu.

Update the package database and core packages:

```
pacman -Syu
```

You will be prompted to close the shell and run the update again. Do so.

Install the vala compiler:

```
pacman -S mingw-w64-x86_64-vala
```

Install GCC and the MINGW64 toolchain:

```
pacman -S mingw-w64-x86_64-toolchain
```

Install meson

```
pacman -S mingw-w64-x86_64-meson
```

# A simple Vala project

## Create a meson build file

Create a new directory for your project.

```
mkdir vala-hello
cd vala-hello
```

The directory will be created in your MSYS2 home directory. Typically, this will be C:\msys64\home\username.


Create a file called meson.build in the directory with the following contents:

```
project('app', 'vala')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  meson.get_compiler('c').find_library('m', required: false)
  ]

sources = files('main.vala'
  )

executable('app', sources, dependencies: dependencies)
```

## Create a Vala source file

Create a file called main.vala in the same directory with the following contents:

```
public static void main () {
    print ("Hello, world!\n");
}
```

## Build the project

Open the MINGW64 shell from the start menu.

Change to the directory containing the meson.build file.

Run the command to configure the build:

```
meson builddir
```

Compile the project:

```
ninja -C builddir
```

Run the project:

```
./builddir/app.exe
```

# Configure Visual Studio Code

Install the Vala plugin for Visual Studio Code.

Add the following to .vscode/settings.json

```
"terminal.integrated.profiles.windows": {
    "MSYS2": {
      "path": "C:\\msys64\\usr\\bin\\bash.exe",
      "args": [
        "--login",
        "-i"
      ],
      "env": {
        "MSYSTEM": "MINGW64",
        "CHERE_INVOKING": "1"
      }
    }
}
```

You will now find that opening a new terminal in VSCode will open a MINGW64 shell, and you can run the meson and ninja commands from within VSCode.


## Add the MSYS2 MINW64 bin directory to your path

To add the C:\msys64\mingw64\bin directory to your PATH environment variable in Microsoft Windows, follow these steps:

* Open the Start menu and search for "System Properties" or "Advanced System Settings" and select the corresponding result.
* In the System Properties window, click on the "Advanced" tab.
* Click on the "Environment Variables" button at the bottom of the window.
* In the Environment Variables window, you'll see two sections: User variables and System variables. We will be modifying the System variables section.
* Scroll down the list of System variables and locate the "Path" variable. Select it and click on the "Edit" button.
* A new Edit Environment Variable window will appear. This window contains a list of semicolon-separated paths. Each path represents a directory in the PATH variable.
* Click on the "New" button and add the path "C:\msys64\mingw64\bin". Make sure to type it exactly as shown here.
* Click "OK" to close the Edit Environment Variable window.
* Click "OK" again to close the Environment Variables window.
* Finally, click "OK" in the System Properties window to save the changes.


## Install the gdb extension for Visual Studio Code

Install the 'GDB Debugger - Beyond' extension for Visual Studio Code.

## Add a launch configuration

In your launch.json file, add the following

```
"configurations": [
    {
        "type": "by-gdb",
        "request": "launch",
        "name": "Launch(gdb)",
        "program": "${workspaceFolder}\\builddir\\app.exe",
        "cwd": "${workspaceRoot}
    }
]
```

## Debugging

You can now debug your application by pressing F5 in Visual Studio Code.

You can insert breakpoints, step through code, and inspect variables.

# Gtk Development

Install Gtk3 using Pacman
```
pacman -S mingw-w64-x86_64-gtk3
```

# Deploying Your Application

## NSIS

Install nsis using Pacman

```
pacman -S mingw-w64-x86_64-nsis
```

## Building Release Code

```
# remove the build directory if it exists
rm -rfd builddir
# configure the build
meson setup --buildtype release builddir
ninja -C builddir
```