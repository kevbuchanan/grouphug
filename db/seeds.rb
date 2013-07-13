require 'digest/md5'
require 'nokogiri'
require 'open-uri'

'http://web.archive.org/web/20071025014638/http://grouphug.us/page/10/n'

module GrouphugScraper
  def self.create_sig(text)
    Digest::MD5.hexdigest(text)
  end

  def self.create_confession(text, id)
    signature = GrouphugScraper.create_sig(text)
    user = User.create_with(type: 'original').find_or_create_by(grouphug_id: id)
    Confession.create(text: text, signature: signature, user_id: user.id)
  end

  def self.parse
    page_num = 10
    10.times do
      html_file = open("http://web.archive.org/web/20071025014638/http://grouphug.us/page/#{page_num}/n")
      page = Nokogiri::HTML(open(html_file))
      confessions = page.css('td.conf-text p').map(&:text)
      confessions.each{ |confession| confession.gsub!(/\s{2,}/, '') }
      users = page.css('td.conf-id a').map(&:text)
      pairs = confessions.zip(users)
      pairs.each { |pair| GrouphugScraper.create_confession(pair[0], pair[1]) }
      page_num += 10
    end
  end
end

GrouphugScraper.parse