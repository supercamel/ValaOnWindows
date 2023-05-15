project('app', 'vala')
dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    meson.get_compiler('c').find_library('m', required: false)
    ]

sources = files(
  'main.vala'
  )

executable('app', sources, dependencies: dependencies, gui_app: true)

