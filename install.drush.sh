#!/usr/bin/env bash
#
# Drush installer for Ubuntu.
#
# Get the OS version.
VERSION=$(cat /etc/lsb-release | grep "DISTRIB_RELEASE=" | sed 's/DISTRIB_RELEASE=//g' | bc)
 
function drush_install_by_pear() {
  apt-get install php-pear
  pear channel-discover pear.drush.org
  pear install drush/drush
  drush
  chmod 777 -R ~/.drush/cache
  echo "Setup done!"
}

function drush_install_by_composer() {
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  composer global require drush/drush:dev-master
  echo "export PATH=$PATH:$HOME/.composer/vendor/bin" >> $HOME/.bashrc
  source $HOME/.bashrc
  echo "Setup done!"
}

if [[ "$VERSION" > "13.10" ]]; then
  drush_install_by_composer 
else
  drush_install_by_pear
fi
