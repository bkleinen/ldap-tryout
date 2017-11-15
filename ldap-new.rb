# http://www.rubydoc.info/gems/ruby-net-ldap/Net/LDAP

# CN=li,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de
	# 	AuthLDAPBindDN CN=ldap,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de



#{ }"ldaps://mars.wh.f4.htw-berlin.de/DC=WH,DC=f4,DC=HTW-BERLIN,DC=DE?cn?sub"

#AuthName "Anmeldung notwendig"
#               AuthType Basic
#               AuthBasicProvider ldap
#               AuthLDAPURL
#"ldaps://mars.wh.f4.htw-berlin.de/DC=WH,DC=f4,DC=HTW-BERLIN,DC=DE?cn?sub"
#               AuthLDAPGroupAttribute member
#               AuthLDAPGroupAttributeIsDN on
#               Require ldap-group
#CN=li,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de
#		AuthLDAPBindDN CN=ldap,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de
#		AuthLDAPBindPassword "PASSWORDPASSWORD"
#
require 'rubygems'
require 'net/ldap'

puts 'export PW=<your passwd> to test' unless password = ENV['PW']



def ldap(password)
  ldap = Net::LDAP.new(
    host: 'mars.wh.f4.htw-berlin.de',
    port: 636,
       encryption: {method: :simple_tls},
       :auth => {
             :method => :simple,
               tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS,
               #username: 'vm',
               username: 'CN=vm,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de',

              # AuthLDAPBindDN CN=vm,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de
            # :username => "uid=vm,CN=ldap,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de",
             :password => password
       })
end


def ldap2(password)
  ldap = Net::LDAP.new(
    encryption: {method: :simple_tls},
    host: 'mars.wh.f4.htw-berlin.de',
    port: 636,
       :auth => {
             :method => :simple,
               username: 'CN=vm,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de',
               password: password
       })
end

def ldap3(password)
  ldap = Net::LDAP.new(
    encryption: {method: :simple_tls},
    host: 'mars.wh.f4.htw-berlin.de',
    port: 636,
       :auth => {
             :method => :simple,
               username: 'CN=kleinen,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de',
               password: password
       })
end


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
          tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS,
        },
        # https://github.com/ruby-ldap/ruby-net-ldap/blob/master/lib/net/ldap.rb
       :auth => {
             :method => :simple,
             #username: "uid=kleinen,CN=ldap,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de",
            # username: "uid=kleinen, CN=li,CN=Users,DC=wh,DC=f4,DC=htw-berlin,DC=de",
             username: "uid=kleinen,DC=WH,DC=f4,DC=HTW-BERLIN,DC=DE",
             #username: "",
             password: password
       }
  if ldap.bind
    puts ldap.inspect
  else
    puts ldap.inspect
    puts "authentication failed"
  end
end

def directory_search(password)
  ldap = ldap2(password)
  filter = Net::LDAP::Filter.eq( "cn", "Kleinen*" )
  treebase = "dc=htw-berlin,dc=de"
puts "trying to search"
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

unless (password = ENV['PW'] && vpassword = ENV['VPW'])
  puts 'export PW=<your passwd> to test'
  puts 'export VPW=<vm passwd> to test'
else
  directory_search(vpassword)
#  authorize(password)
end
