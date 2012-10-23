Yet another initial Rails app for start up
======
这些代码整理改进自我八月到九月开发的喜感网<http://www.xigan.com>第一版的基础部分的代码，希望能对其他的创 业者快速开发原型产品时有所帮助。也希望能够帮我review代码，共同进步吧。我会不定期把改进合并进这里。

OAuth部分实现有些有些繁琐，对国内网站OAuth2的实现感到有些无语。

##组件
- 完整的部署流程（release code to server+bundle+migrate database+assets precompile+sync assets to upyun+hot deployment）
- 用户子系统
- 微博 人人的Oauth接口（逻辑实现复杂了，考虑未来重构）+ 初步的API调用封装
- 配置集中化
- 若干实用的Helper
- 初步的管理员后台
- Kindeditor集成+图片上传的服务器端

##方案
- Ruby管理：RVM
- Ruby: Ruby 1.9.3
- 框架：Rails 3.2
- 数据库：MySQL
- 文件上传：Carrierwave + 又拍云
- 缓存、KV存储：Memcache + Redis
- 任务队列、延迟任务：Resque + Resque-scheduler
- 服务器和站点监控：New relic
- 程序异常反馈：Airbrake
- 部署：Capistrano
- 邮件发送：Postfix / Gmail
- 反向代理：Nginx
- Web容器：Unicorn

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
