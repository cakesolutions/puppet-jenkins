define jenkins::plugin::install($version = 0) {
  $user              = $jenkins::jenkins_user
  $group             = $jenkins::jenkins_group
  $plugin            = "${name}.hpi"
  $plugin_parent_dir = "$jenkins::jenkins_home/plugin"
  $plugin_dir        = "$jenkins::jenkins_home"

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url   = 'http://updates.jenkins-ci.org/latest/'
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
