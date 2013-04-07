require "open-uri"
require "nokogiri"
require "pry"

class Ripper
  attr_accessor :html, :css

  def initialize(uri)
    @doc = Nokogiri::HTML(open(uri))
    rip
  end

  def css
    %Q{
      div.page {
        text-align:center;
      }
      div.page.image img {
        max-height: 100%;
      }
      div.page.title {
        font-size: 24px;
      }
    }
  end

  private

  def rip
    images = @doc.css("#slides img")
    titles = @doc.css("#slides .title")
    captions = @doc.css("#slides .caption")

    story do
      images.each_with_index do |image, index|
        title = titles[index].text
        unless title.nil? || title.empty?
          add_slide(title, class: "title")
        end
        image_url = image["src"]
        add_slide("<img src='#{image_url}' />", class: "image")
      end
    end
  end

  def story
    @html = '<div class="story">'
    yield
    @html += '</div>'
  end

  def add_slide(html_content, options = {})
    @html += %Q{<div class="page #{options[:class]}">#{html_content}</div>}
  end
end
