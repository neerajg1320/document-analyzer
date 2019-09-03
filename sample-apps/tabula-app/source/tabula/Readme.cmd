#https://github.com/tabulapdf/tabula

# If ruby and rvm are not installed
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s stable —ruby

rvm install "jruby-9.2.0.0"
rvm use jruby-9.2.0.0

# Add following line at the end of ~/.bashrc
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

git clone git://github.com/tabulapdf/tabula.git
cd tabula

sudo gem install bundler
bundle install

jruby -S jbundle install

jruby -G -r jbundler -S rackup
