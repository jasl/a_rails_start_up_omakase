ActionView::Base.send(:include, Kindeditor::Helper)
ActionView::Helpers::FormBuilder.send(:include, Kindeditor::Builder)

ActionView::Base.send(:include, District::Helper)
ActionView::Helpers::FormBuilder.send(:include, District::Builder)
