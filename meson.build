project('caar-os')

as = ''

if meson.is_subproject()
  as = subproject('as').get_variable('assembler_executable')
else
  as = find_program('caar-as')
endif

input_files = [
  'src/loader/loader.lisp',
  'src/main.lisp'
]

outfile = 'os.img'

install_dir = join_paths(meson.current_source_dir(), 'bin')

if meson.is_subproject()
  install_dir = join_paths(meson.current_source_dir(), '../../bin')
endif

gen = generator(as,
                output  : '@BASENAME@.o',
                arguments : ['@INPUT@', '-o', '@OUTPUT@','-I', join_paths(meson.current_source_dir(), 'src')])

output = gen.process(input_files)

cat_prog = find_program('cat')

concat_parts = custom_target(
  'concat-parts',
  command: [ cat_prog, '@INPUT@'],
  capture: true,
  input: output,
  output: 'os.img',
  build_by_default: true
)
