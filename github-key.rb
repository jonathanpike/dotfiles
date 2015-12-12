require 'github_api'
require 'io/console'
require 'socket'

# Bypass annoying deprecation warning between the
# github_api gem and the faraday gem

Faraday::Builder = Faraday::RackBuilder

# Get Github Credentials

print "Github Username: "
user_name = gets.strip
print "Github Password (nothing will be displayed):"
password  = STDIN.noecho(&:gets).strip

# Get current hostname for key title

hostname = Socket.gethostbyname(Socket.gethostname).first
hostname.gsub!(/\.local/, '')

# Add key to Github

github = Github.new(:login => user_name, :password => password)
github.users.keys.create("title" => "#{hostname}", 
	"key"=> File.open("~/.ssh/id_rsa.pub").read)
puts "\nAdded ssh key to GitHub!"
