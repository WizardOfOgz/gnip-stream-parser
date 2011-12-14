require 'sergio'
require 'rexml/document' # Hack: Using this to unescape link HREFs, but why isn't that happening already?

class SergioActivityStreamPost
  include Sergio

  element 'entry' do
    element 'id'
    element 'link', :attribute => 'href', :having => {:rel => 'alternate'} do |v| 
      REXML::Text::unnormalize(v)
    end
    element 'summary', 'body'
    element 'published', 'postedTime'

    element 'activity:object', 'object' do
      element 'title'
      element 'subtitle'
      element 'thr:content'
      element 'content', 'summary'

      element 'activity:object-type', 'objectType' do |v|
        v.match(/http:\/\/activitystrea.ms\/schema\/1.0\/(.*)/)[1]
      end

      element 'link', 'image', :attribute => 'href', :having => {:rel => 'preview'} do |v| 
        REXML::Text::unnormalize(v)
      end
      element 'link', :attribute => 'href', :having => {:rel => 'alternate'} do |v| 
        REXML::Text::unnormalize(v)
      end
      element 'link', 'target', :attribute => 'href', :having => {:rel => 'enclosure'} do |v| 
        REXML::Text::unnormalize(v)
      end
    end

    element 'activity:author', 'actor' do
      element 'gnip:friends', 'followersCount', :attribute => 'followersCount'
      element 'gnip:friends', 'followingCount', :attribute => 'followingCount'
      element 'link', 'image', :attribute => 'href', :having => {:rel => 'avatar'}
    end

    element 'author', 'actor' do
      element 'name', 'displayName'
      element 'uri', 'preferredUsername' do |v|
        if v =~ /twitter/
          v.match(/http:\/\/(www\.|)twitter\.com\/(.*)/)[2]
        end
      end
      element 'uri', 'link'
      element 'id'
    end

    element 'activity:actor', 'actor' do
      element 'gnip:stats', 'statusesCount', :attribute => 'activityCount'
      element 'gnip:stats',  'id', :attribute => 'upstreamId'
      element 'os:aboutMe', 'summary' do |v|
        v if v.is_a?(String)
      end
    end

    element 'service:provider', 'provider' do
      element 'name', 'displayName'
      element 'uri', 'link'
    end

    element ['gnip:matching_rules', 'gnip:matching_rule'], ['gnip', 'matching_rules'], :as_array => true do |v, attrs|
      {'value' => v, 'tag' => attrs['tag']}
    end
  end

  element 'entry', ['entry', 'provider'], :attribute => 'gd:kind' do |v|
    provider_name = ''
    provider_link = ''

    if v == 'buzz#activity'
      provider_name = 'Google Buzz'
      provider_link = 'http://google.com'
    end

    {'displayName' => provider_name, 'link' => provider_link}
  end

  def initialize(xml)
    @xml = xml
    @username_regexp = /http:\/\/twitter\.com\/(.*?)\/statuses\/(.*)/
  end

  def to_json_activity_stream_hash
    self.parse(@xml)['entry']
  end

  private

  def method_missing(method, *args, &proc)
    r = @doc[method.to_s]
  end
end
