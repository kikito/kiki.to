###
# Site settings
###

set :site_author, "Enrique García Cota"
set :site_title, "kiki.to"
set :site_url, "http://kiki.to"


###
# Blog settings
###

activate :syntax
activate :autoprefixer, browsers: ['last 2 versions', 'Explorer >= 9']

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true, :with_toc_data => true

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  blog.permalink = "{year}/{month}/{day}/{title}.html"
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

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Nice links
activate :directory_indexes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'
set :layouts_dir, 'layouts'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
