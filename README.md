Yet another initial Rails app for start up
======
这些代码整理改进自我八月到九月开发的喜感网<http://www.xigan.com>第一版的基础部分的代码，同时也是第二版的基础，希望这里面的代码能对他人快速开发产品原型有所帮助。也希望能够帮我review代码，共同进步。我会不定期把改进合并进这里。这个repo另一个目的是记录我对rails app架构的想法。

或许对于Startup的快速迭代来说，MongoDB才是正确的选择。

##自己YY的一些practice
- lib/extras kindeditor和district_select的tag helper
- lib/oauth_handlers 或许可以抽取成gem，利用facade pattern把人人、微博的相同作用的api包装成统一接口，app/models/authorization.rb 利用delegate直接调用
- config/environments/production.rb 自定义了一套assets预编译规则，对重型js lib（例如kindeditor）友善
- config/environments/production.rb 如果在application.yml里配置assets的bucket，直接让upyun接管所有assets
- config/deploy.rb 你可以只给你的部署账号sudo no password service的权限，释放init.d脚本利用try_su来解决，保证部署账号的权限足够的低并且能够进行一些高危操作
- lib/generators/script_generator 利用rails generator生成init.d脚本，脚本山寨自gitlab，配合rake task实现释放到/etc/init.d 然后chkconfig on
- 开发环境下使用foreman管理app的所有进程，配置在Procfile里，config/environments/development.rb里的```$stdout.sync = true```使得rails log立即输出到stdout
- app/uploaders/image_uploader.rb 修改了huacnlee的实现，默认图片作为一个asset处理

##组件
- 完整的部署流程（release code to server+bundle+migrate database+assets precompile+sync assets to upyun+hot deployment）
- 用户子系统
- 微博 人人的Oauth接口+ 初步的API调用封装
- 配置集中化
- 若干实用的Helper
- 初步的管理员后台(独立的namespace放与业务有关配合Rails_admin)
- Kindeditor集成+图片上传的服务器端

##方案
- Ruby管理：RVM
- Ruby: Ruby 1.9.3
- 框架：Rails 3.2
- 数据库：MySQL
- 文件上传：Carrierwave + 又拍云
- 缓存、KV存储：Memcache + Redis
- 任务队列、延迟任务：Resque + Rescue-Scheduler
- 服务器和站点监控：New relic
- 程序异常反馈：Airbrake
- 程序后台：Rails_admin
- 部署：Capistrano
- 邮件发送：Postfix / others
- 反向代理：Nginx
- Web容器：Unicorn
- 日志分析：request-log-analyzer

##Gems
- 用户系统：devise + omniauth
- OAuth api：weibo_2 renren
- 访问控制：cancan
- 通知：acts-as-messageable
- Tag：acts-as-taggable-on
- 评论：acts_as_commentable
- 分页：kaminari
- 全局配置：settingslogic
- 前端：compass-rails + jquery-ui-rails + bootstrap

##运行开发环境
- git clone
- bundle
- rake db:migrate
- foreman start
- 访问localhost:3000

##部署
- 需要 git、rvm、rvm requirements中的给出的组建
- 配置 nginx（见doc/nginx.conf.sample）
- 建立专用部署用户（如deploy）给予执行service的sudo权限（见config/deploy.rb注释）
- 根据需要取消Gemfile中new relic和airbrake的注释，配置config/application.yml database.yml new_relic.yml，模板见各自的sample 
- cap deploy:setup
- cap deploy:check 调整直到全部通过
- cap deploy 有时候sync_to_cdn会出现异常，重试即可
- cap db:seed 导入初始数据（如有修改，自行编辑db/seeds.rb）
- 第一次运行需要执行cap service:setup 生成init.d文件
- cap service:start
- 没有问题，访问你的域名，否则请检查log/unicorn.stderr.log和log/production.log排除

##注意事项
- assets precompile：左右app/assets和vendor/assets下的文件名非‘_’开头文件都会被预编译，避免手动添加。不希望被预编译的第三方lib，考虑放到lib/assets对应目录下。
- set_title set_description set_keywords 这三个helper可以调用多次 会产生如 ‘Home - Admin - Start Up'的层级效果
- kindeditor不能把他的js后置，所以为了解决这个问题，你需要在使用他的页面上<% has_kindeditor %>
- 富文本输出<%= safe @post.body %>


jasl, MIT license.
