
require 'net/ldap'

def try_searchyourself
  ldap = Net::LDAP.new(host: "141.45.146.101", port: 389)
  treebase = "o=f4, dc=htw-berlin, dc=de"
  f = Net::LDAP::Filter.eq( "uid", "s0550488" )
  uid = "kleinen"
  pw = ENV['PW']
  ldap.auth "uid=#{uid}, ou=Users, o=f4, dc=htw-berlin, dc=de", "#{pw}"

  dn = "uid=#{uid},ou=Users,o=f4,dc=htw-berlin,dc=de"

  # :gn
  # :sn
  # :email

  ldap.open do |ldap|
    ldap.search( :base => dn) do |entry|
       #
       # @gn = entry.givenname
       # @sn = entry.sn
       # @email = entry.mail
      entry.each do |attribute, values|



        puts "   #{attribute}:"
        values.each do |value|
          puts "      --->#{value}"
        end
      end
      # puts entry
    end
  end
end

try_searchyourself
