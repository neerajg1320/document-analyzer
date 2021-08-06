#https://github.com/tabulapdf/tabula

# If gpg is not installed
# gpg is required to download ruby and rvm
brew install gpg2

# https://usabilityetc.com/articles/ruby-on-mac-os-x-with-rvm/
# If ruby and rvm are not installed
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source /Users/neeraj/.rvm/scripts/rvm

rvm install "jruby-9.2.0.0"
rvm use jruby-9.2.0.0

# Add following line at the end of ~/.bashrc
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

git clone git://github.com/tabulapdf/tabula.git
cd tabula

gem install bundler -v 1.17.3
bundle install

jruby -S jbundle install
jbundle update
jruby -G -r jbundler -S rackup
