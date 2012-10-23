# -*- encoding : utf-8 -*-

puts "Importing locations."

Location.create :province => '北京',
                :city => '北京'

%w(朝阳区 东城区 西城区 海淀区 丰台区 石景山区 大兴区 通州区 昌平区).each do |d|
  Location.create :province => '北京',
                  :city => '北京',
                  :district => d
end

puts "Generating default users..."

admin = User.new :email => 'jasl123@126.com',
                 :password => 'aaaaaa'
admin.role = :admin
admin.save

User.create :email => 'demo@demo.com',
            :password => 'aaaaaa'

puts "Admin user - email: jasl123@126.com password: aaaaaa"
puts "Demo user - email: demo@demo.com password: aaaaaa"
