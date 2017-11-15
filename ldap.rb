# http://www.rubydoc.info/gems/ruby-net-ldap/Net/LDAP

#{ }"ldaps://mars.wh.f4.htw-berlin.de/DC=WH,DC=f4,DC=HTW-BERLIN,DC=DE?cn?sub"


require 'rubygems'
require 'net/ldap'

puts 'export PW=<your passwd> to test' unless password = ENV['PW']

def authorize(password)
  ldap = Net::LDAP.new
  #ldap.host = "mars.wh.f4.htw-berlin.de"
  #ldap.port = 389
  #ldap.auth 'kleinen', password
  ldap = Net::LDAP.new :host => 'mars.wh.f4.htw-berlin.de',
       #:port => 389,
       port: 636,
       encryption:
       {
          method: :simple_tls,
          # tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS,
          verify_mode: OpenSSL::SSL::VERIFY_NONE
        },
        # https://github.com/ruby-ldap/ruby-net-ldap/blob/master/lib/net/ldap.rb
       :auth => {
             :method => :simple,
             username: "CN=kleinen,OU=Users,OU=imi,DC=wh,DC=f4,DC=htw-berlin,DC=de",
             password: password
          }
  if ldap.bind
    ldap.bind
    puts ldap.inspect
    puts "authentication ok"
  else
    ldap.bind
    puts ldap.inspect
    puts "authentication failed"
  end
end

def directory_search(password)
  ldap = Net::LDAP.new :host => 'mars.wh.f4.htw-berlin.de',
       :port => 636,
       encryption: {method: :simple_tls},
       :auth => {
             :method => :simple,
               tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS,
             :username => "CN=kleinen,OU=Users,OU=imi,DC=wh,DC=f4,DC=htw-berlin,DC=de",           # Es geht aber auch mit User kleinen (s.o.)
             :password => password
       }
  #ldap.encryption(encryption: :simple_tls )
  filter = Net::LDAP::Filter.eq( "givenname", "bar*" )
  #  filter = Net::LDAP::Filter.eq( "sn", "klein*" )

  #filter = Net::LDAP::Filter.eq( "CN", "s0558434" )
  treebase = "OU=Users,OU=imi,DC=wh,DC=f4,DC=htw-berlin,DC=de"

  ldap.search( :base => treebase, :filter => filter ) do |entry|
    puts "DN: #{entry.dn}"
    entry.each do |attribute, values|
      puts "   #{attribute}:"
      values.each do |value|
        puts "      --->#{value}"
      end
    end
  end

  p ldap.get_operation_result
end

unless (password = ENV['PW'] && vpassword = ENV['PW'])
  puts 'export PW=<your passwd> to test'
else
  directory_search(vpassword)
  #authorize(password)
end
