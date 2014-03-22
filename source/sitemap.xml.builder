---
layout: false
---

xml.instruct!
xml.urlset 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.find_all{ |p| File.extname(p.path) == '.html' && p.path != '404.html'  }.each do |page|
    xml.url do
      xml.loc URI.join(settings.site_url, page.url)
      xml.lastmod Date.today.to_time.iso8601
      xml.changefreq page.data.changefreq || "monthly"
      xml.priority page.data.priority || "0.5"
    end
  end
end
