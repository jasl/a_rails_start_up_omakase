# encoding: utf-8
module District
  # glory to shopqi
  class District
    CHINA = '000000' # 全国
    PATTERN = /(\d{2})(\d{2})(\d{2})/

    def self.list(parent_id = '000000')
      result = []
      return result if parent_id.blank?
      province_id = self.province(parent_id)
      city_id = self.city(parent_id)
      children = self.data
      children = children[province_id][:children] if children.has_key?(province_id)
      children = children[city_id][:children] if children.has_key?(city_id)
      children.each_key do |id|
        result.push [ children[id][:text], id]
      end

      #sort
      result.sort! {|a, b| a[1] <=> b[1]}
      result
    end

    # @options[:prepend_parent] 是否显示上级区域
    def self.get(id, options = {})
      return '' if id.blank?
      prepend_parent ||= options[:prepend_parent]
      children = self.data
      return children[id][:text] if children.has_key?(id)
      province_id = self.province(id)
      province_text = children[province_id][:text]
      children = children[province_id][:children]
      return "#{prepend_parent ? (province_text + " ") : ''}#{children[id][:text]}" if children.has_key?(id)
      city_id = self.city(id)
      city_text = children[city_id][:text]
      children = children[city_id][:children]
      return "#{prepend_parent ? (province_text + " " + city_text) : ''} #{children[id][:text]}"
    end

    def self.try_nested_get(options = {})
      if !options[:district].blank?
        value = options.delete(:district)
      elsif !options[:city].blank?
        value = options.delete(:city)
      elsif !options[:province].blank?
        value = options.delete(:province)
      else
        value = ""
      end
      get value, options
    end

    begin 'parse' # 解析出省市区编码

    def self.match(code)
      code.match(PATTERN)
    end

    def self.province(code)
      self.match(code)[1].ljust(6, '0')
    end

    def self.city(code)
      id_match = self.match(code)
      "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
    end

    end

    private
    def self.data
      unless @list
        #{ '440000' =>
        #  {
        #    :text => '广东',
        #    :children =>
        #      {
        #        '440300' =>
        #          {
        #            :text => '深圳',
        #            :children =>
        #              {
        #                '440305' => { :text => '南山' }
        #              }
        #           }
        #       }
        #   }
        # }
        @list = {}
        #@see: http://github.com/RobinQu/LocationSelect-Plugin/raw/master/areas_1.0.json
        json = JSON.parse(File.read("#{Rails.root}/db/areas.json"))
        districts = json.values.flatten
        districts.each do |district|
          id = district['id']
          text = district['text']
          if id.end_with?('0000')
            @list[id] =  {:text => text, :children => {}}
          elsif id.end_with?('00')
            province_id = self.province(id)
            @list[province_id] = {:text => nil, :children => {}} unless @list.has_key?(province_id)
            @list[province_id][:children][id] = {:text => text, :children => {}}
          else
            province_id = self.province(id)
            city_id = self.city(id)
            @list[province_id] = {:text => text, :children => {}} unless @list.has_key?(province_id)
            @list[province_id][:children][city_id] = {:text => text, :children => {}} unless @list[province_id][:children].has_key?(city_id)
            @list[province_id][:children][city_id][:children][id] = {:text => text}
          end
        end
      end
      @list
    end
  end

  module Helper
    def district_select_tags(name, value = '000000', options = {})
      input_html = options.delete(:input_html) || {}
      output_buffer = ActiveSupport::SafeBuffer.new
      output_buffer << '<div class="district_select">'.html_safe
      output_buffer << select_tag("#{name}[province]",
                           options_for_select(::District.list ,"#{value[0..1]}0000"),
                           {prompt: '--省份--', id: sanitize_to_id("#{name}[province]")}.merge(input_html))
      output_buffer << select_tag("#{name}[city]",
                           value[0..1]!='00' ? options_for_select(::District.list("#{value[0..1]}0000") ,"#{value[0..3]}00") : "",
                           {prompt: '--城市--', id: sanitize_to_id("#{name}[city]")}.merge(input_html))
      output_buffer << select_tag("#{name}[district]",
                           value[2..3]!='00' ? options_for_select(::District.list("#{value[0..3]}00") ,value) : "",
                           {prompt: '--地区--', id: sanitize_to_id("#{name}[district]")}.merge(input_html))
      output_buffer << '</div>'.html_safe
    end

  end

  module Builder
    def district_selects(options = {})
      if !@object.district.blank?
        value = @object.district
      elsif !@object.city.blank?
        value = @object.city
      elsif !@object.province.blank?
        value = @object.province
      else
        value = "000000"
      end

      @template.send("district_select_tags", @object_name, value, objectify_options(options))
    end
  end

  class << self
    delegate :list, :get, :try_nested_get, :to => District
  end
end
