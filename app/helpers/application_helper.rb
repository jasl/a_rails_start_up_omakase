module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def print_error_messages resource
    return '' if resource.errors.empty?
    errors = resource.errors.full_messages.uniq
    messages = errors.map { |msg| content_tag(:li, msg) }.join
    if errors.count > 1
      sentence = I18n.t("errors.messages.not_saved.other",
                        :count => errors.count)
    else
      sentence = I18n.t("errors.messages.not_saved.one")
    end

    html = <<-HTML
    <div class="alert alert-error">
      <a class="close" data-dismiss="alert"><i class="icon-remove"></i></a>
      <strong>#{sentence}</strong>
      <ul>
        #{messages}
      </ul>
    </div>
    HTML

    html.html_safe
  end

  # Glory to Xdite form bootstrap-helper
  def safe(html)
    sanitize( html, :tags => %w(table thead tbody tr td th ol ul li div span font img sup sub br hr a pre p h1 h2 h3 h4 h5 h6), :attributes => %w(style src href size color) )
  end

  def notice_message
    flash_messages = []
    flash.each do |type, message|
      if message
        type = :success if type == :notice
        html = <<-HTML
        <div class=\"alert fade in alert-#{type}\">
          <a class="close" data-dismiss="alert"><i class="icon-remove"></i></a>
          #{message}
        </div>
        HTML
        flash_messages << html
      end
    end
    flash_messages.join("\n").html_safe
  end

  def set_title(title = "", is_root = false)
    if is_root
      title_str = title
    else
      title_str = "#{title} - "
    end

    content_for :title do
      title_str
    end
  end

  def set_keywords(keywords = [], with_default = true)
    keys = keywords
    if with_default
      keys += Setting.keywords
    end
    content_for :keywords do
      keys.join(',')
    end
  end

  def set_description(description = "")
    content_for :description do
      description || Setting.description
    end
  end

  def has_specified_javascript(js = controller_path)
    content_for :js do
      javascript_include_tag js
    end
  end

  def has_specified_stylesheet(css = controller_name)
    content_for :css do
      stylesheet_link_tag css, :media => "all"
    end
  end

  def has_kindeditor
    unless defined? @has_kindeditor
      has_specified_javascript 'kindeditor'
      @has_kindeditor = true
    end

  end
end
