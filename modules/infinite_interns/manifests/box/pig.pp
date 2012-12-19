# Apache Pig Infinite Intern
class infinite_interns::box::pig {

  require common::devel

  $url = 'http://mirror.ox.ac.uk/sites/rsync.apache.org/pig/pig-0.10.0'
  $filename = 'pig_0.10.0-1_i386.deb'

  exec {
    'download-pig-deb':
      command => "/usr/bin/wget ${url}/${filename}",
      cwd     => '/root',
      creates => "/root/${filename}",
      timeout => 0;
  }

  package {
    'pig':
      ensure   => installed,
      provider => dpkg,
      source   => "/root/${filename}";
  }

  Exec['download-pig-deb'] -> Package['pig']

}
