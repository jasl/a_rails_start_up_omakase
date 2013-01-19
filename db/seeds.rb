# -*- encoding : utf-8 -*-

puts "Generating default users..."

admin = User.new :email => 'jasl123@126.com',
                 :password => 'aaaaaa'
admin.role = :admin
admin.save!

puts "Admin user - email: jasl123@126.com password: aaaaaa"

if Rails.env.development?
  user = User.create :email => 'demo@demo.com',
                     :password => 'aaaaaa'

  puts "Demo user - email: demo@demo.com password: aaaaaa"

  100.times do |i|
    p = Post.new :title => "Post - #{i}", :body => "Test"*100
    p.user = [admin, user].shuffle.first
    p.save!
    100.times do |j|
      c = p.comments.build :body => "Comment#{j}"
      c.user = [admin, user].shuffle.first
      c.save!
    end
  end
end

puts "Done."
