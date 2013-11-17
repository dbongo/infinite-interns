# Refine Infinite Intern
class infinite_interns::box::refinebeta {

  require java

  group {
    'refine': ensure => present
  }

  user {
    'refine':
      ensure     => present,
      gid        => refine,
      groups     => admin,
      shell      => '/bin/bash',
      managehome => true
  }

  file {
    '/etc/init.d/refine':
      source => 'puppet:///modules/infinite_interns/etc/init.d/refine',
      owner  => root,
      group  => root,
      mode   => '0744';

    '/etc/init/refine.conf':
      source => 'puppet:///modules/infinite_interns/etc/init/refinebeta.conf',
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  $url = 'https://github.com/OpenRefine/OpenRefine/releases/download/2.6-beta.1'
  $filename = 'openrefine-linux-2.6-beta.1.tar.gz'
  $extracted = 'openrefine-2.6-beta.1'

  file {
    '/etc/profile.d/refine.sh':
      ensure  => present,
      content => "export PATH=\$PATH:/opt/${extracted}\n",
      owner   => root,
      group   => root,
      mode    => 0644;
  }

  exec {
    'download-refine':
      command => "/usr/bin/wget ${url}/${filename}",
      cwd     => '/root',
      creates => "/root/${filename}",
      timeout => 0;

    'install-refine':
      command => "/bin/tar xzf /root/${filename}",
      cwd     => '/opt',
      creates => "/opt/${extracted}",
      timeout => 0;
  }

  service {
    'refine':
      ensure   => running,
      enable   => true,
      provider => 'upstart';
  }

  Group[refine] -> User[refine] -> Service[refine]

  File['/etc/init.d/refine'] -> Service[refine]
  File['/etc/init/refine.conf'] -> Service[refine]

  Exec[download-refine] -> Exec[install-refine] -> Service[refine]
}
