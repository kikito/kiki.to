---
layout: false
---

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = settings.site_url
  xml.title settings.site_author
  xml.subtitle "Blog"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name "<%= site_url %>" }

  listed_articles[0..9].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name settings.site_author }
      xml.summary article.summary, "type" => "html"
      xml.content "#{article.body} <p><a href='#{URI.join(site_url, article.url)}#comments'>Go to the full site to see the comments</a></p>", "type" => "html"
    end
  end
end
