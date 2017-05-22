require 'net/ldap'

ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)

#auth = ldap.bind(method: :simple, username: "uid=kleinen, ou=Users, o=f4, dc=htw-berlin, dc=de", password: "#{ENV["PW"]}")
#auth = ldap.bind(method: :simple, username: "uid=kleinen, ou=Users, o=f4, dc=htw-berlin, dc=de", password: "#{ENV["PW"]}")
auth = 9
puts "authorization successful: #{auth} (#{auth.class})"


# serach
treebase = "o=f4, dc=htw-berlin, dc=de"
f = Net::LDAP::Filter.eq( "uid", "kleinen" )

r = ldap.search(:base => treebase, :filter => f)

# Net::LDAP::Entry

puts r.size
e = r.first
puts e.inspect

puts e.uid
puts e.objectclass

 # filter = Net::LDAP::Filter.eq("cn", "*") -> formatierungsfehler


 #<Net::LDAP::Entry:0x007f9763832a50 @myhash={:dn=>["uid=kleinen,ou=Users,o=f4,dc=htw-berlin,dc=de"], :objectclass=>["top", "posixAccount", "shadowAccount", "sambaSamAccount", "inetOrgPerson"], :uid=>["kleinen"], :uidnumber=>["6650"], :gecos=>["Benutzer"], :gidnumber=>["204"], :homedirectory=>["/home/kleinen"], :loginshell=>["/bin/bash"]}>
# alle accounts am fachbereich
# treebase = "o=f4, dc=htw-berlin, dc=de"
# f = Net::LDAP::Filter.eq( "uid", "*" )
# r = ldap.search(:base => treebase, :filter => f)
# puts r.map(&:uid).inspect


treebase = "o=f4, dc=htw-berlin, dc=de"
f = Net::LDAP::Filter.eq( "uid", "*" )
r = ldap.search(:base => treebase, :filter => f)
puts ldap.get_operation_result
puts r.map(&:uid).inspect
