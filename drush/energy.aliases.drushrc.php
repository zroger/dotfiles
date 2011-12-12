<?php

$aliases['local'] = array(
  'uri' => 'http://energy.local:3000/',
  'root' => '/Users/zroger/treehouse/energy.gov/docroot',
  'command-specific' => array(
    'site-install' => array(
      'site-name' => 'Energy.gov (local)',
    ),
  ),
);

$aliases['dev'] = array(
  'remote-host' => 'dev.cms.doe.gov',
  'remote-user' => 'rlopez',
  'root' => '/var/www/vhosts/energy.gov/docroot',
  'path-aliases' => array(
    '%dump-dir' => '/tmp/',
  ),
);

