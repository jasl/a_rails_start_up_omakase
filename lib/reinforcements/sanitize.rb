require 'sanitize'

class Sanitize
  module Transformers
    CleanEvilCSS = lambda { |env|
      node      = env[:node]
      node_name = env[:node_name]
      # Don't continue if this node is already whitelisted or is not an element.
      return if env[:is_whitelisted] || !node.element?
      # parent = node.parent
      return unless node_name == 'style' || node['style']
      if node_name == 'style'
        unless good_css? node.content
          node.unlink
          return
        end
      else
        unless good_css? node['style']
          node.unlink
          return
        end
      end
      {:whitelist_node => [node]}
    }

    # inspired by https://github.com/courtenay/css_file_sanitize/blob/master/lib/css_sanitize.rb
    def self.good_css? text
      return false if text =~ /(\w\/\/)/    # a// comment immediately following a letter
      return false if text =~ /(\w\/\/*\*)/ # a/* comment immediately following a letter
      return false if text =~ /(\/\*\/)/            # /*/ --> hack attempt, IMO

      # Now, strip out any comments, and do some parsing.
      no_comments = text.gsub(/(\/\*.*?\*\/)/, "") # filter out any /* ... */
      no_comments.gsub!("\n", "")
      # No backslashes allowed
      evil = [
          /(\bdata:\b|eval|cookie|\bwindow\b|\bparent\b|\bthis\b)/i, # suspicious javascript-type words
          /behaviou?r|expression|moz-binding|@import|@charset|(java|vb)?script|[\<]|\\\w/i,
          /[\<>]/, # back slash, html tags,
          /[\x7f-\xff]/, # high bytes -- suspect
          /[\x00-\x08\x0B\x0C\x0E-\x1F]/, #low bytes -- suspect
          /&\#/, # bad charset
      ]

      # incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string) Error Support.
      begin
        evil.each { |regex| return false if no_comments =~ regex }
      rescue
        return false
      end
      true
    end
  end

  module Config
    RICH = {
        :elements => %w[
        a abbr b bdo blockquote br caption cite code col colgroup dd del dfn dl
        dt em figcaption figure h1 h2 h3 h4 h5 h6 hgroup i img ins kbd li mark
        ol p pre q rp rt ruby s samp small strike strong sub sup table tbody td
        tfoot th thead time tr u ul var wbr div span
        ],

        :attributes => {
            :all => %w[dir lang title style],
            'a' => %w[href],
            'blockquote' => %w[cite],
            'col' => %w[span width],
            'colgroup' => %w[span width],
            'del' => %w[cite datetime],
            'img' => %w[align alt height src width],
            'ins' => %w[cite datetime],
            'ol' => %w[start reversed type],
            'q' => %w[cite],
            'table' => %w[summary width],
            'td' => %w[abbr axis colspan rowspan width],
            'th' => %w[abbr axis colspan rowspan scope width],
            'time' => %w[datetime pubdate],
            'ul' => %w[type]
        },

        :protocols => {
            'a' => {
                'href' => ['ftp', 'http', 'https', 'mailto', :relative]
            },
            'blockquote' => {
                'cite' => ['http', 'https', :relative]
            },
            'del' => {
                'cite' => ['http', 'https', :relative]
            },
            'img' => {
                'src' => ['http', 'https', :relative]
            },
            'ins' => {
                'cite' => ['http', 'https', :relative]
            },
            'q' => {
                'cite' => ['http', 'https', :relative]
            }
        },
        :transformers => [Sanitize::Transformers::CleanEvilCSS]
    }
  end
end

class String
  def sanitize
    Sanitize.clean self, Sanitize::Config::RICH
  end
end
