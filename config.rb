require 'htmlentities'

###
# Site settings
###
set :site_lang, 'en'
set :site_author, "Enrique García Cota"
set :site_title, "kiki.to"
set :site_url, "http://kiki.to"

###
# Middleman settings
###
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'
set :layouts_dir, 'layouts'
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true, :with_toc_data => true, :autolink => true

###
# Plugins
###

activate :syntax

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

activate :autoprefixer, browsers: ['last 2 versions', 'Explorer >= 9']

activate :disqus do |d|
  d.shortname = "kikito"
end

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  blog.permalink = "{year}/{month}/{day}/{title}"
  blog.layout = "post"
  blog.summary_separator = /(<!-- MORE -->)/
  blog.default_extension = ".md"
end

activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :rsync
  deploy.host   = 'kiki.to'
  deploy.path   = '~/nginx/www'
end

# Nice links
activate :directory_indexes


# Build-specific configuration
configure :development do
  activate :google_analytics do |ga|
    ga.tracking_id = false
  end
end

configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  activate :google_analytics do |ga|
    ga.tracking_id = 'UA-49731031-1'
    ga.domain_name = 'kiki.to'
  end

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end


###
# Helpers
###

helpers do
  def superstrip(str)
    coder = HTMLEntities.new
    coder.decode(strip_tags(str)).gsub(/\n/, " ").strip
  end

  def page_title
    buffer = [site_title]
    if current_article && current_article.title.present?
      buffer << current_article.title
    else
      buffer << current_page.data.title if current_page.data.title.present?
    end
    superstrip(buffer.join ' | ')
  end

  def meta_description
    description = ''
    if current_article.present?
      description = current_article.summary
    else
      description = current_page.data.title if current_page.data.title.present?
    end
    superstrip(description)
  end

  def listed_articles
    blog.articles
      .select{ |a| a.data.listed != false }
      .sort_by{ |a| "#{a.date}#{a.title}" }
      .reverse
  end

  def feed_url
    "#{blog.options.prefix.to_s}/feed.xml"
  end

  def feed_title
    "#{site_title} - Atom Feed"
  end

  def google_analytics
    options = ::Middleman::GoogleAnalytics.options
    tracking_id = options.tracking_id
    domain_name = options.domain_name
    if tracking_id
      %{
      <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', '#{tracking_id}', '#{domain_name}');
        ga('send', 'pageview');
      </script>
      }
    end
  end
end
