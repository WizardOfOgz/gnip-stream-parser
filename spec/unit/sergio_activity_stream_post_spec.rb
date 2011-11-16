require 'spec_helper'

describe SergioActivityStreamPost do
  context 'with a Twitter post' do
    before do
      @post = SergioActivityStreamPost.new(File.open(File.dirname(__FILE__) + '/../support/twitter_activity_stream.xml', 'r').read)
    end

    context 'to_json_activity_stream_hash' do
      before do
        @hash = @post.to_json_activity_stream_hash
      end

      it 'parses the id' do
        @hash['id'].should == "tag:search.twitter.com,2005:71230904948883456"
      end

      it 'parses the post link' do
        @hash['link'].should == "http://twitter.com/_P3PP_CE/statuses/71230904948883456"
      end

      it 'parses the postedTime' do
        @hash["postedTime"].should == "2011-05-19T15:09:05+00:00"
      end

      it 'parses the body' do
        @hash["body"].should == "@mrpotatochipman cool ;)"
      end

      context 'actor' do
        before do
          @actor = @hash['actor']
        end

        it 'parses the displayName' do
          @actor['displayName'].should  == 'P3PP'
        end

        it 'parses the preferredUsername' do
          @actor['preferredUsername'].should  == '_P3PP_CE'
        end

        it 'parses the id' do
          @actor['id'].should  == 'id:twitter.com:125163780'
        end

        it 'parses the link' do
          @actor["link"].should == "http://www.twitter.com/_P3PP_CE"
        end

        it 'parses the image' do
          @actor["image"].should == "http://a0.twimg.com/profile_images/1352659419/l_15_normal.jpg"
        end

        it 'parses the statusesCount' do
          @actor["statusesCount"].should == "22964"
        end

        it 'parses the followingCount' do
          @actor["followingCount"].should == "839"
        end

        it 'parses the followersCount' do
          @actor["followersCount"].should == "911"
        end
      end

      context 'object' do
        before do
          @object = @hash['object']
        end

        it 'parses the objectType' do
          @object["objectType"].should == "note"
        end

        it 'parses the link' do
          @object["link"].should == "http://twitter.com/_P3PP_CE/statuses/71230904948883456"
        end

        it 'parses the summary' do
          @object["summary"].should == "@mrpotatochipman cool ;)"
        end
      end

      context 'gnip' do
        before do
          @gnip = @hash['gnip']
        end

        it 'parses the matching rules' do
          @gnip["matching_rules"].should == [{"tag"=>"NEAT", "value"=>"cool"}]
        end
      end

      context 'provider' do
        before do
          @provider = @hash['provider']
        end

        it 'parses the displayName' do
          @provider["displayName"].should == "Twitter"
        end

        it 'parses the link' do
          @provider["link"].should == "http://www.twitter.com/"
        end
      end
    end
  end

  context 'with a Facebook post' do
    before do
      @post = SergioActivityStreamPost.new(File.open(File.dirname(__FILE__) + '/../support/facebook_activity_stream.xml', 'r').read)
    end

    context 'to_json_activity_stream_hash' do
      before do
        @hash = @post.to_json_activity_stream_hash
      end

      it 'parses the id' do
        @hash['id'].should == "100000601711657_225559834120776"
      end

      it 'parses the post link' do
        @hash['link'].should == "http://www.facebook.com/profile.php?id=100000601711657&v=wall&story_fbid=225559834120776"
      end

      it 'parses the postedTime' do
        @hash["postedTime"].should == "2011-05-19T23:13:57+00:00"
      end

      it 'parses the body' do
        @hash["body"].should == nil
      end

      context 'actor' do
        before do
          @actor = @hash['actor']
        end

        it 'parses the displayName' do
          @actor['displayName'].should  == 'Shane Smith'
        end

        it 'parses the preferredUsername' do
          @actor['preferredUsername'].should  == nil
        end

        #it 'parses the id' do
        #  @actor['id'].should  == 'id:twitter.com:125163780'
        #end

        it 'parses the link' do
          @actor["link"].should == "http://www.facebook.com/profile.php?id=100000601711657"
        end
      end

      context 'object' do
        before do
          @object = @hash['object']
        end

        it 'parses the objectType' do
          @object["objectType"].should == "bookmark"
        end

        it 'parses the link' do
          @object["link"].should == "http://www.facebook.com/profile.php?id=100000601711657&v=wall&story_fbid=225559834120776"
        end

        it 'parses the summary' do
          @object["summary"].should == "Come to my Graduation Party on June 18th!!!"
        end

        it 'parses the image' do
          @object["image"].should == 'http://profile.ak.fbcdn.net/hprofile-ak-snc4/187804_184487541600108_5482560_s.jpg'
        end
      end

      context 'gnip' do
        before do
          @gnip = @hash['gnip']
        end

        it 'parses the matching rules' do
          @gnip["matching_rules"].should == [{"tag"=>nil, "value"=>"party"}, {"tag"=>nil, "value"=>"neat"}]
        end
      end

      context 'provider' do
        before do
          @provider = @hash['provider']
        end

        it 'parses the displayName' do
          @provider["displayName"].should == "Facebook"
        end

        it 'parses the link' do
          @provider["link"].should == "www.facebook.com"
        end
      end
    end
  end

  context 'with a Buzz post' do
    before do
      @post = SergioActivityStreamPost.new(File.open(File.dirname(__FILE__) + '/../support/buzz_activity_stream.xml', 'r').read)
    end

    context 'to_json_activity_stream_hash' do
      before do
        @hash = @post.to_json_activity_stream_hash
      end

      it 'parses the id' do
        @hash['id'].should == "tag:google.com,2010:buzz:z12dgfjgkwabv3egs04ch3kqzqnscp2xvhc"
      end

      it 'parses the post link' do
        @hash['link'].should == "https://profiles.google.com/101327999921150687436/posts/SUjANDpeWVo"
      end

      it 'parses the postedTime' do
        @hash["postedTime"].should == "2011-05-20T15:30:02.000Z"
      end

      it 'parses the body' do
        @hash["body"].should == nil
      end

      context 'actor' do
        before do
          @actor = @hash['actor']
        end

        it 'parses the displayName' do
          @actor['displayName'].should  == 'Roy Patrick Tan'
        end

        it 'parses the preferredUsername' do
          @actor['preferredUsername'].should  == nil
        end

        #it 'parses the id' do
        #  @actor['id'].should  == 'id:twitter.com:125163780'
        #end

        it 'parses the link' do
          @actor["link"].should == "https://profiles.google.com/101327999921150687436"
        end
      end

      context 'object' do
        before do
          @object = @hash['object']
        end

        it 'parses the objectType' do
          @object["objectType"].should == "note"
        end

        it 'parses the link' do
          @object["link"].should == "https://profiles.google.com/101327999921150687436/posts/SUjANDpeWVo"
        end

        it 'parses the summary' do
          @object["summary"].should == "Seated figure"
        end
      end

      context 'provider' do
        before do
          @provider = @hash['provider']
        end

        it 'parses the displayName' do
          @provider["displayName"].should == "Google Buzz"
        end

        it 'parses the link' do
          @provider["link"].should == "http://google.com"
        end
      end
    end
  end
end
