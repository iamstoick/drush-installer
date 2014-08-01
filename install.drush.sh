#!/usr/bin/env bash
#
# @file
#   Drush installer for Ubuntu.
#
# @author
#   Gerald Z. Villorente
#

# Get the OS version.
VERSION=$(cat /etc/lsb-release | grep "DISTRIB_RELEASE=" | sed 's/DISTRIB_RELEASE=//g' | bc)

# Install script for Ubuntu 13.10 and lower.
# Requires php-pear.
function drush_install_by_pear() {
  apt-get install php-pear
  pear channel-discover pear.drush.org
  pear install drush/drush
  drush
  chmod 777 -R ~/.drush/cache
}

# Install script for Ubuntu 14.04 and higher.
# Requires composer.
function drush_install_by_composer() {
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  composer global require drush/drush:dev-master
  echo "export PATH=$PATH:$HOME/.composer/vendor/bin" >> $HOME/.bashrc
  source $HOME/.bashrc
}

echo "Running Drush installation..."
if [[ "$VERSION" > "13.10" ]]; then
  drush_install_by_composer 
else
  drush_install_by_pear
fi
echo "Setup done! Happy Drushing!"
