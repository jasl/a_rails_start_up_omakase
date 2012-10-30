# -*- encoding : utf-8 -*-

puts "Generating default users..."

admin = User.new :email => 'jasl123@126.com',
                 :password => 'aaaaaa'
admin.role = :admin
admin.save

User.create :email => 'demo@demo.com',
            :password => 'aaaaaa'

puts "Admin user - email: jasl123@126.com password: aaaaaa"
puts "Demo user - email: demo@demo.com password: aaaaaa"
