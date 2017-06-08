require 'net/ldap'



def try_auth
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)
  puts "export PW=<your passwd> to test " unless ENV["PW"]
  auth = ldap.bind(method: :simple, username: "uid=kleinen, ou=Users, o=f4, dc=htw-berlin, dc=de", password: "#{ENV["PW"]}")
  puts "authorization successful: #{auth} (#{auth.class})"
end

def try_search
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)
  # search
  treebase = "o=f4, dc=htw-berlin, dc=de"
  f = Net::LDAP::Filter.eq( "uid", "kleinen" )

  r = ldap.search(:base => treebase, :filter => f)

  # Net::LDAP::Entry

  puts r.size
  e = r.first
  puts e.inspect

  puts e.uid
  puts e.objectclass
end


 # filter = Net::LDAP::Filter.eq("cn", "*") -> formatierungsfehler


 #<Net::LDAP::Entry:0x007f9763832a50 @myhash={:dn=>["uid=kleinen,ou=Users,o=f4,dc=htw-berlin,dc=de"], :objectclass=>["top", "posixAccount", "shadowAccount", "sambaSamAccount", "inetOrgPerson"], :uid=>["kleinen"], :uidnumber=>["6650"], :gecos=>["Benutzer"], :gidnumber=>["204"], :homedirectory=>["/home/kleinen"], :loginshell=>["/bin/bash"]}>
# alle accounts am fachbereich
# treebase = "o=f4, dc=htw-berlin, dc=de"
# f = Net::LDAP::Filter.eq( "uid", "*" )
# r = ldap.search(:base => treebase, :filter => f)
# puts r.map(&:uid).inspect

def try_search2
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)
  treebase = "o=f4, dc=htw-berlin, dc=de"
  f = Net::LDAP::Filter.eq( "uid", "*" )
  r = ldap.search(:base => treebase, :filter => f)
  puts ldap.get_operation_result
  puts r.map(&:uid).inspect
  puts r.first
  puts r.size
end

#try_auth
#try_search
try_search2
