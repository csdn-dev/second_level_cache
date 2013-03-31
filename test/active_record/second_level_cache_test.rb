# -*- encoding : utf-8 -*-
require 'active_record/test_helper'

class ActiveRecord::SecondLevelCacheTest < Test::Unit::TestCase
  def setup
    @user = User.create :name => 'csdn', :email => 'test@csdn.com'
    @topic = Topic.create :title => 'csdn'
  end

  def test_should_get_cache_key
    assert_equal "slc/user/#{@user.id}/#{User::CacheVersion}", @user.second_level_cache_key
  end

  def test_should_write_and_read_cache
    @user.write_second_level_cache
    assert_not_nil User.read_second_level_cache(@user.id)
    @user.expire_second_level_cache
    assert_nil User.read_second_level_cache(@user.id)
  end

  def test_should_expire_cache
    @topic.write_second_level_cache
    assert_not_nil Topic.read_second_level_cache(@topic.id)
    sleep 3
    assert_nil Topic.read_second_level_cache(@topic.id)
  end

  def test_should_fetch_cache
    assert_nil SecondLevelCache.cache_store.read('fragment')
    fragment = SecondLevelCache.cache_store.fetch('fragment', :expires_in => 2) do
      @user.to_s
    end
    assert_equal fragment, @user.to_s
    assert_equal SecondLevelCache.cache_store.read('fragment'), @user.to_s
    sleep 3
    assert_nil SecondLevelCache.cache_store.read('fragment')
  end
end
