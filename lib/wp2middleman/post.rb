require 'html2markdown'

module WP2Middleman
  class Post
    attr_accessor :post

    def initialize(nokogiri_post_doc)
      @post = nokogiri_post_doc
    end

    def title
      post.css('title').text
    end

    def link
      post.css('link').text
    end

    def valid?
      !(post_date.nil? || title.nil? || date_time_published.nil? || content.nil? || link.nil?)
    end

    def attachment?
      type == 'attachment'
    end

    def field(field)
      post.xpath(field).first.inner_text
    end

    def post_date
      post.xpath("wp:post_date").first.inner_text
    end

    def date_published
      Date.parse(post_date).to_s
    end

    def date_published_short_slug
      Date.parse(post_date).strftime("%Y-%m").to_s
    end

    def date_time_published
      Time.parse(post_date).strftime("%F %T")
    end

    def status
      post.xpath("wp:status").first.inner_text
    end

    def type
      post.xpath("wp:post_type").first.inner_text
    end

    def published?
      status == 'publish'
    end

    def content
      post.at_xpath(".//content:encoded").inner_text
    end

    def tags
      tags = []
      categories = post.xpath("category")

      categories.each do |category|
        tag_name = category.css("@nicename").text

        tags.push tag_name unless tag_name == 'uncategorized'
      end

      tags
    end
  end
end
