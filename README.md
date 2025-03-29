# ValaOnWindows

This tutorial guides new programmers through the process of setting up a Vala development environment on Windows using MSYS2, configuring Visual Studio Code (VSCode) for Vala projects, and deploying applications. Let's begin.

# Contents

* [Install msys2](#install-msys2)
* [Install Vala](#install-vala)
    * [Meson](#meson)
* [Creating a Vala Project](#creating-a-vala-project)
    * [Set up the project structure](#set-up-the-project-structure)
    * [Write your Vala code](#write-your-vala-code)
    * [Building and Running the Project](#building-and-running-the-project)
* [Vala and Visual Studio Code](#vala-and-vistual-studio_code)
    * [Configure Visual Studio Code](#configure-visual-studio-code)
    * [Add the MSYS2 MINGW64 bin directory to your path](#add-the-msys2-mingw64-bin-directory-to-your-path)
    * [Install the GDB Extension for Visual Studio Code](#install-the-gdb-extension-for-visual-studio-code)
    * [Adding a Launch Configuration for Debugging](#adding-a-launch-configuration-for-debugging)
    * [Debugging Your Application](#debugging-your-application)
* [Gtk Development](#gtk-development)
* [Deploying Your Application](#deploying-your-application)
    * [NSIS (Nullsoft Scriptable Install System)](#nsis-nullsoft-scriptable-install-system)
    * [Building Release Code](#building-release-code)
    * [Deployment](#deployment)
    * [Applying a Custom Theme](#applying-a-custom-theme)
* [Building Libraries](#building-libraries)

# Install msys2

Download and install msys2 from https://www.msys2.org/

MSYS2 is a software distribution and a development platform for Windows. It provides a Unix-like environment which makes it easier to port and run Unix software on Windows. MSYS2 includes a command-line terminal, a package manager (Pacman), and a selection of updated, easily-installable Unix tools.

For Vala development specifically, MSYS2 is particularly useful because:

1. Package Management: MSYS2's package manager, Pacman, simplifies the process of installing and updating software, including the Vala compiler, libraries, and tools necessary for development.

2. Unix-like Environment: Many programming tools, including those used in Vala development, originate from Unix-like systems and often have better support and more features in these environments. MSYS2 provides a Unix-like shell and environment which can make working with these tools more straightforward.

3. MINGW64: This component of MSYS2 provides a set of compilers and libraries that can create Windows 64-bit executables that do not depend on a compatibility layer. This is important for creating native Windows applications.

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
You will be prompted to make a selection. Press enter to accept and install all packages in the group. 

## Meson 

Meson is a fast and user-friendly build system designed to handle the needs of modern software developers. It is the build system of choice for many large scale projects as it simplifies the build process and reduces compilation times. In the context of Vala, Meson manages dependencies, compiles the source code, and links the result into an executable program or library, all with simple, high-level configuration.

Install Meson:

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

# Vala and Visual Studio Code

Vala, with its modern syntax and powerful features, allows developers to write complex and efficient software with less effort. Being part of the GObject type system, Vala is inherently compatible with a large number of libraries written in C, making it a robust choice for GTK development.

In this setup, Visual Studio Code (VSCode) serves as our primary code editor. While there are many code editors available, VSCode stands out due to its extensive language support, robust plugin ecosystem, and deep integration capabilities. The Vala extension in VSCode offers features like syntax highlighting, and VSCode's built-in terminal can be integrated with MSYS2, providing an unified development environment. This setup ensures that developers can write, build, and debug Vala code efficiently, all within the same workspace.

# Configure Visual Studio Code

1. Install the Vala plugin for Visual Studio Code.
2. Open the Command Palette (CTRL + SHIFT + P)
3. Enter and select the "Preferences: Open User Settings (JSON) Option
4. Add the following configuration:

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
},
"terminal.integrated.defaultProfile.windows": "MSYS2"
```

This configuration sets up the MSYS2 MINGW64 shell as the integrated terminal in Visual Studio Code. It allows you to run Meson and Ninja commands directly from within the editor.

Save the settings.json file.

With this configuration, opening a new terminal in Visual Studio Code will launch the MINGW64 shell, giving you direct access to the Vala build tools.


## Add the MSYS2 MINGW64 bin directory to your path

Add the MINGW64 bin directory to your PATH environment variable in Microsoft Windows. The default location is C:\msys64\mingw64\bin.

Follow these steps:

* Open the Start menu and search for "System Properties" or "Advanced System Settings" and select the corresponding result.
* In the System Properties window, click on the "Advanced" tab.
* Click on the "Environment Variables" button at the bottom of the window.
* In the Environment Variables window, you'll see two sections: User variables and System variables. We will be modifying the System variables section.
* Scroll down the list of System variables and locate the "Path" variable. Select it and click on the "Edit" button.
* A new Edit Environment Variable window will appear. This window contains a list of semicolon-separated paths. Each path represents a directory in the PATH variable.
* Click on the "New" button and enter the MINGW64 bin directory. The default location is "C:\msys64\mingw64\bin". 
* Click "OK" to close the Edit Environment Variable window.
* Click "OK" again to close the Environment Variables window.
* Finally, click "OK" in the System Properties window to save the changes.


## Install the GDB Extension for Visual Studio Code

To enable debugging support for Vala projects in Visual Studio Code, install the "GDB Debugger - Beyond" extension by following these steps:

Go to the Extensions view by clicking on the square icon in the left sidebar or pressing Ctrl+Shift+X.

Search for "Native Debug" in the extensions search bar.

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
            "target": ".\\builddir\\app.exe",
            "cwd": "${workspaceRoot}"
        }
    ]
}
```

This configuration specifies the type of debugger to use, the request to launch the debugger, the name of the launch configuration, the path to the compiled executable file, and the current working directory.

Note: if you have not install GDB, use the command `pacman -S mingw-w64-x86_64-gdb`

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

Update the dependencies in meson.build to include gtk3
```
dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk+-3.0'),
  meson.get_compiler('c').find_library('m', required: false)
]
```

Tell meson that the executable is now a GUI application. This prevents the console window from appearing when the application is run.
```
executable('app', sources, dependencies: dependencies, gui_app: true)
```

# Deploying Your Application

## NSIS (Nullsoft Scriptable Install System)

NSIS is a professional open source system that is used to create Windows installers. It is script-driven, which allows you to automate the creation of your installers, and it has a minimal overhead size-wise, which keeps your installers lightweight. NSIS makes it easy for end users to install software, and it gives you the ability to include everything that your software requires, such as runtime libraries, in one single installer. This greatly simplifies the process of software distribution and installation.

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

## Deployment

The [gtk_app example](https://github.com/supercamel/ValaOnWindows/tree/main/gtk_app) contains a script called 'deploy.sh'

This bash script automates the process of creating an installer for a GTK application on Windows. The script performs the following operations:

1. Setting Up Variables: The script initializes variables containing important details of your application. This includes the application name, executable name, build directory, deploy directory, theme name, and icon file path.

2. Directory Creation and Structuring: The script creates the essential directories (bin, etc, share) within your defined deployment directory.

3. DLL Copying: The script identifies the necessary DLL dependencies of your application executable using the ldd command, and copies these DLL files from MINGW64/bin directory to the bin directory in the deploy folder.

4. Copying Required GTK Files: The script copies additional necessary files for GTK to function correctly. This includes certain executables, configuration files, libraries, shared resources, and theme files. The files are taken from various mingw64 directories and copied into their respective directories in the deploy folder.

5. Creating NSIS Script: The script automatically generates an NSIS script that defines the appearance and functionality of your installer, including the installation and uninstallation procedures, shortcut creation, and writing necessary registry keys. The script is saved with the name ${app_name}Installer.nsi.

6. Running NSIS: The script executes makensis to create the installer executable from the generated NSIS script.

Remember to adjust the variables at the start of the script to align with the specific details of your project. This script serves as a convenient tool to automate the process of creating a Windows installer for your GTK application.

This script works well for simple cases. However, with the addition of complex dependencies, more files might need inclusion in the deploy directory. The 'pacman' tool can provide a list of files installed in the MSYS environment, helping discern necessary dependency-related files. For example, if 'libjpeg' is a dependency, 'pacman -Ql mingw-w64-x86_64-libjpeg-turbo' can list all its associated files installed in the MSYS environment. Identifying these files can aid in deciding what needs to be added to the deploy directory. This script is a helpful starting point for building installers.


## Applying a Custom Theme
To apply a custom theme, download one from sources like gnome-look.org. For example, the Peace-GTK theme:

[Peace-GTK Theme](https://github.com/L4ki/Peace-Plasma-Themes/tree/main)

Download the theme and copy the Peace-GTK folder to **C:\msys64\mingw64\share\themes**.
Create a new file **C:\msys64\mingw64\etc\gtk-3.0\settings.ini** with the following content:
```
[Settings]
gtk-theme-name=Peace-GTK
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintful
gtk-xft-rgba=rgb
```
Launch builddir/app to see the new theme applied.
Update the deploy.sh script to set the theme name as "Peace-GTK" (or your preferred theme), and the installed application will use this theme.

# Building Libraries 

To build libraries with GObject Introspection and make them available for use in Vala applications, follow these steps:

1. Install GObject Introspection:

```
pacman -S mingw-w64-x86_64-gobject-introspection
```

This command installs the necessary package for GObject Introspection under MSYS2.

2. Develop your Vala library using the Vala library template:

[Vala library template](https://github.com/supercamel/vala_lib_template)

Use the Vala library template repository as a starting point for developing your library. The template provides a foundation for building a Vala library that can be easily integrated with other Vala applications.

Note that the Vala library template is inherently cross platform and can be used to build libraries under both Windows and Linux. 

3. Build and install your library:

Follow the instructions in the Vala library template repository to build and install your library using Meson. Once installed, your library will be available for use in other Vala applications.

4. Add the library as a dependency:

In your Vala application's Meson build file, add your library as a dependency. This ensures that your application can use the functions, objects, and types provided by your library.

For example, in your Meson build file, add the following line to include the library as a dependency:

```
dependencies = [
  ...
  dependency('your-library-name'),
  ...
]
```

Replace 'your-library-name' with the actual name of your library.

5. Use your library in your Vala application:

In your Vala application's source code, import and use the functions, objects, and types provided by your library as needed. This allows you to leverage the functionality of your library within your application. The deploy script used earlier will automatically detect and include required DLLs for your new library, however if your library includes other assets you will need to modify the deploy script to include those assets. 

Note: Your Vala library can also be used with other languages like Python and Lua under MSYS2 through GObject Introspection. For example, in Python, you can use the gi.repository module to access the Vala library's functionality. Here's a small Python snippet as an example:

```
from gi.repository import YourLibraryName

# Use the functions, objects, and types provided by YourLibraryName
```
By following these steps, you can build libraries with GObject Introspection and make them readily available for use in Vala applications, as well as other supported languages like Python and Lua under MSYS2.
