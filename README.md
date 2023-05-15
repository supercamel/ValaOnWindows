# ValaOnWindows

This guide will walk you through setting up Vala development on Windows using MSYS2, configuring Visual Studio Code for Vala projects, and deploying your application. Follow the steps below to get started.

# Install msys2

Download and install msys2 from https://www.msys2.org/

Msys2 is a unix-like environment for Windows. It provides a shell, pacman package manager, and other tools commonly found in a unix environment.

The installer will install multiple environments for different compilers. We will use the MSYS2 MINGW64 environment. 

# Install Vala

Open the MINGW64 shell from the Start menu.

Update the package database and core packages by running the following command:

```
pacman -Syu
```

Follow the prompts to close the shell and run the update again.

Install the Vala compiler by running:

```
pacman -S mingw-w64-x86_64-vala
```

Install GCC and the MINGW64 toolchain by running:

```
pacman -S mingw-w64-x86_64-toolchain
```

Install Meson, a build system, by running:

```
pacman -S mingw-w64-x86_64-meson
```

# Creating a Vala Project
## Set up the project structure

Create a new directory for your project:

```
mkdir vala-hello
cd vala-hello
```

Note: The directory will be created in your MSYS2 home directory, typically located at C:\msys64\home\username.

Create a file called meson.build in the vala-hello directory and add the following contents:

```
project('app', 'vala')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  meson.get_compiler('c').find_library('m', required: false)
]

sources = files('main.vala')

executable('app', sources, dependencies: dependencies)
```

## Write your Vala code

Create a file called main.vala in the vala-hello directory and add the following contents:

```
public static void main() {
    print("Hello, world!\n");
}
```


## Building and Running the Project

Open the MINGW64 shell from the Start menu.

Change to the directory containing the meson.build file:

```
cd vala-hello
```

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

In Visual Studio Code, open the .vscode/settings.json file and add the following configuration:

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

This configuration sets up the MSYS2 MINGW64 shell as the integrated terminal in Visual Studio Code. It allows you to run Meson and Ninja commands directly from within the editor.

Save the settings.json file.

With this configuration, opening a new terminal in Visual Studio Code will launch the MINGW64 shell, giving you direct access to the Vala build tools.


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


## Install the GDB Extension for Visual Studio Code

To enable debugging support for Vala projects in Visual Studio Code, install the "GDB Debugger - Beyond" extension by following these steps:

Go to the Extensions view by clicking on the square icon in the left sidebar or pressing Ctrl+Shift+X.

Search for "GDB Debugger - Beyond" in the extensions search bar.

Click on the extension and select "Install".

The extension will be downloaded and installed.

## Adding a Launch Configuration for Debugging

To set up a launch configuration for debugging your Vala application in Visual Studio Code, follow these steps:

1. Open Visual Studio Code and navigate to the Debug view by clicking on the bug icon in the left sidebar or pressing Ctrl+Shift+D.

2. In the Debug view, locate the "No Configurations" drop-down menu and click on it. Choose "Add Configuration" to create a new launch configuration.

3. Select "GDB" as the debug environment for Vala.

4. Replace the contents of the launch.json file with the following configuration:

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "gdb",
            "request": "launch",
            "name": "Launch(gdb)",
            "program": "${workspaceFolder}\\builddir\\app.exe",
            "cwd": "${workspaceRoot}"
        }
    ]
}
```

This configuration specifies the type of debugger to use, the request to launch the debugger, the name of the launch configuration, the path to the compiled executable file, and the current working directory.

# Debugging Your Application

To start debugging your Vala application in Visual Studio Code, follow these steps:

1. Open your Vala project in Visual Studio Code.

2. Set breakpoints in your code by clicking in the left gutter of the editor window where you want the program execution to pause.

3. Press F5 or click on the "Start Debugging" button in the Debug view to begin debugging.

4. The program will start running, and it will pause at the breakpoints you set. You can step through the code, inspect variables, and control the execution flow using the debugging toolbar.

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