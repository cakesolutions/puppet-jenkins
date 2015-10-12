define jenkins::plugin($version=0) {
  $user              = $jenkins::jenkins_user
  $group             = $jenkins::jenkins_group
  $plugin            = "${name}.hpi"
  $plugin_dir        = "$jenkins::jenkins_home/plugins"
  $plugin_parent_dir = "$jenkins::jenkins_home"

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = 'http://updates.jenkins-ci.org/latest/'
  }

  if (!defined(File[$plugin_parent_dir])) {
    file {
      $plugin_parent_dir:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        recurse => true,
        require => [ Package["jenkins"] ],
    }
  }

  if (!defined(File[$plugin_dir])) {
    file { $plugin_dir:
        ensure    => directory,
          owner   => $user,
          group   => $group,
          recurse => true,
          require => [ Package["jenkins"], File[$plugin_parent_dir] ],
    }
  }

  exec {
    "download-${name}" :
      command  => "wget --no-check-certificate ${base_url}${plugin}",
      cwd      => $plugin_dir,
      require  => File[$plugin_dir],
      path     => ['/usr/bin', '/usr/sbin',],
      user     => $user,
      unless   => "test -f ${plugin_dir}/${plugin}",
      notify   => Service['jenkins'];
  }
}
