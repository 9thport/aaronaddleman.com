# this command for os x
sudo port -vvv install oniguruma4

# this command for debian
sudo apt-get -y install libonig-dev

# add the following to your config.ru file before run Nesta::App
echo "use Rack::Codehighlighter, :ultraviolet, :element => \"pre>code\", :markdown => true, :theme => \"eiffel\"" >> config.ru
echo "run Nesta::App" >> config.ru

gem install ultraviolet
gem install rspec-core -v='2.11.1'
gem install rspec-expectations -v='2.11.2'
gem install rspec-mocks -v='2.11.2'
gem install rspec -v='2.11.0'