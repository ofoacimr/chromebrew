require 'package'
Package.load_package("#{__dir__}/llvm16_build.rb")

class Llvm16_lib < Package
  description 'LibLLVM and llvm-strip'
  homepage Llvm16_build.homepage
  version '16.0.6'
  # When upgrading llvm_build*, be sure to upgrade llvm_lib* and llvm_dev* in tandem.
  puts "#{self} version differs from llvm version #{Llvm16_build.version}".orange if version != Llvm16_build.version
  license Llvm16_build.license
  compatibility 'all'
  source_url 'SKIP'
  binary_compression 'tar.zst'

  binary_sha256({
    aarch64: '996924278cd5695a0fee50649498a95b30417af629eb3b0edad66b4805fc5e9c',
     armv7l: '996924278cd5695a0fee50649498a95b30417af629eb3b0edad66b4805fc5e9c',
       i686: 'd7796f4b22c14c73cab97265fa0b94305fb10de2764a11e857e2049287afdc8e',
     x86_64: '76eb8ce408c2260479fb73f82ec5a9e1f895e34b4bcc77a88a8f46eed38c2ba0'
  })

  depends_on 'gcc_lib' # R
  depends_on 'glibc' # R
  depends_on 'libedit' # R
  depends_on 'libffi' # R
  depends_on 'libxml2' # R
  depends_on 'llvm16_build' => :build
  depends_on 'ncurses' # R
  depends_on 'zlib' # R
  depends_on 'zstd' # R

  def self.install
    puts 'Installing llvm16_build to pull files for build...'.lightblue
    @filelist_path = File.join(CREW_META_PATH, 'llvm16_build.filelist')
    abort 'File list for llvm16_build does not exist!'.lightred unless File.file?(@filelist_path)
    @filelist = File.readlines(@filelist_path, chomp: true).sort

    @filelist.each do |filename|
      next unless (filename.include?('.so') && filename.include?('libLLVM')) || filename.include?('llvm-strip')

      @destpath = File.join(CREW_DEST_DIR, filename)
      @filename_target = File.realpath(filename)
      FileUtils.install @filename_target, @destpath
    end
  end
end
