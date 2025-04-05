##
# @package Showcase-Openapi-Asciidoc
#
# @file Readme builder
# @copyright 2025-present Christoph Kappel <christoph@unexist.dev>
# @version $Id$
#
# This program can be distributed under the terms of the GNU GPLv3.
# See the file LICENSE for details.
##

require 'rss'
require 'open-uri'

BLOG_URL = 'https://unexist.blog/feed.xml'
FILE_NAME = 'README.adoc'

def fetch_posts()
  posts = []

  URI.open(BLOG_URL) do |rss|
    feed = RSS::Parser.parse(rss)

    posts.push ''

    feed.items.each do |item|
      posts.push "- %s[%s - %s]\n" % [ item.link.href, item.updated.content.strftime("%Y-%m-%d"), item.title.content ]
    end
  end

  posts
end

def update_file(file_name, start_marker, end_marker, new_content)
  start_idx = 0
  end_idx = -1

  content = File.readlines file_name

  content.each_with_index do |line, idx|
    start_idx = idx if line.start_with? start_marker
    end_idx = idx if line.start_with? end_marker
  end

  content = [content[0..start_idx], new_content, content[end_idx..-1]].flatten.join

  File.write file_name, content
end

# Main
posts_ary = fetch_posts()

update_file(FILE_NAME, '// blog-start', '// blog-end', posts_ary)