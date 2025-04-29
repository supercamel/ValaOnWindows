# Vala on Windows Setup Guide

## Install MSYS2
- Download and install MSYS2 from [msys2.org](https://www.msys2.org/).
- Use the MINGW64 environment for Vala development.

## Install Vala and Tools
Open the MINGW64 shell and run:
```
pacman -Syu
pacman -S mingw-w64-x86_64-vala mingw-w64-x86_64-toolchain mingw-w64-x86_64-meson
```

## Create a Vala Project
1. Create a project directory:
```
mkdir vala-hello
cd vala-hello
```

2. Create `meson.build`:
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

3. Create `main.vala`:
```
public static void main() {
    print("Hello, world!\n");
}
```

4. Build and run:
```
meson builddir
ninja -C builddir
./builddir/app.exe
```

## Set Up Visual Studio Code
1. Install the Vala plugin.
2. Configure the MSYS2 terminal in `settings.json`:
```
"terminal.integrated.profiles.windows": {
    "MSYS2": {
      "path": "C:\\msys64\\usr\\bin\\bash.exe",
      "args": ["--login", "-i"],
      "env": {"MSYSTEM": "MINGW64", "CHERE_INVOKING": "1"}
    }
},
"terminal.integrated.defaultProfile.windows": "MSYS2"
```

3. Add `C:\msys64\mingw64\bin` to your Windows PATH.
4. Install the "Native Debug" extension for GDB.
5. Create `launch.json` for debugging:
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

6. Install GDB if needed:
```
pacman -S mingw-w64-x86_64-gdb
```

7. Debug by setting breakpoints and pressing F5.

## GTK Development
1. Install GTK3:
```
pacman -S mingw-w64-x86_64-gtk3
```

2. Update `meson.build` dependencies:
```
dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk+-3.0'),
  meson.get_compiler('c').find_library('m', required: false)
]
executable('app', sources, dependencies: dependencies, gui_app: true)
```

## Deploy Your Application
1. Install NSIS:
```
pacman -S mingw-w64-x86_64-nsis
```

2. Build release code:
```
rm -rfd builddir
meson setup --buildtype release builddir
ninja -C builddir
```

3. Use a deployment script (e.g., [gtk_app example](https://github.com/supercamel/ValaOnWindows/tree/main/gtk_app)) to:
   - Copy DLLs and GTK files.
   - Generate an NSIS installer script.
   - Run `makensis` to create the installer.

4. Apply a custom theme (e.g., Peace-GTK):
   - Download and copy to `C:\msys64\mingw64\share\themes`.
   - Create `C:\msys64\mingw64\etc\gtk-3.0\settings.ini`:
```
[Settings]
gtk-theme-name=Peace-GTK
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintful
gtk-xft-rgba=rgb
```
   - Update the deployment script to include the theme.

## Build Libraries
1. Install GObject Introspection:
```
pacman -S mingw-w64-x86_64-gobject-introspection
```

2. Use the [Vala library template](https://github.com/supercamel/vala_lib_template) to develop and build your library.
3. Add the library as a dependency in your `meson.build`:
```
dependencies = [
  dependency('your-library-name'),
  ...
]
```

4. Use the library in your Vala code and update the deployment script to include additional assets if needed.
