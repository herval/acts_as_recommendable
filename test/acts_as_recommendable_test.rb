require File.dirname(__FILE__) + '/test_helper'

class Book < ActiveRecord::Base
  has_many :user_books
  has_many :users, :through => :user_books
end

class UserBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :user_books
  has_many :books, :through => :user_books
  acts_as_recommendable :books, :through => :user_books
end


class ActsAsRecommendableTest < ActiveSupport::TestCase
  
  def setup
    @users = (1..10).collect { |n| User.create(:name => "Patient #{n}") }
    @books = (1..20).collect { |n| Book.create(:name => "Book #{n}") }

    (1..8).collect { |n| UserBook.create(:user_id => 1, :book_id => n) }    
    [2, 4, 5, 7, 8].collect { |n| UserBook.create(:user_id => 2, :book_id => n) }
    [3, 4, 5, 6].collect { |n| UserBook.create(:user_id => 3, :book_id => n) }
    [9, 10, 11].collect { |n| UserBook.create(:user_id => 4, :book_id => n) }
    [9, 10].collect { |n| UserBook.create(:user_id => 5, :book_id => n) }
    [1, 2, 19, 20].collect { |n| UserBook.create(:user_id => 6, :book_id => n) }
    [1, 2, 20].collect { |n| UserBook.create(:user_id => 7, :book_id => n) }
    [12, 13, 14, 15, 1, 10, 20].collect { |n| UserBook.create(:user_id => 8, :book_id => n) }
    [12, 13, 1, 10, 20].collect { |n| UserBook.create(:user_id => 9, :book_id => n) }
    [14, 1, 10, 20].collect { |n| UserBook.create(:user_id => 10, :book_id => n) }
  end
  
  def test_available_methods
    user = User.find(@users[0].id)
    assert_not_nil user
    assert_respond_to user, :similar_users
    assert_respond_to user, :recommended_books
  end
  
  def test_similar_users
    sim_users = get_sim_users
    assert_not_nil sim_users
  end
  
  def test_similar_users_format
    sim_users = get_sim_users
    assert_kind_of Array, sim_users
    assert_kind_of User, sim_users.first
    assert_kind_of Numeric, sim_users.first.similar_score
  end
  
  def test_similar_users_results
    sim_users = get_sim_users
    assert sim_users.include?(User.find(2))
    assert_respond_to sim_users[0], :similar_score
    assert !sim_users.include?(User.find(5))
  end
  
  def test_similar_users_scores
    sim_users = get_sim_users
    assert_respond_to sim_users[0], :similar_score
    assert sim_users[0].similar_score > 0
  end

  def test_recommended_books
    recommended_books = get_recommend_books
    assert_not_nil recommended_books
  end
  
  def test_recommended_books_format
    recommended_books = get_recommend_books
    assert_kind_of Array, recommended_books
    assert_kind_of Book, recommended_books.first
    assert_kind_of Numeric, recommended_books.first.recommendation_score
  end
  
  def test_recommended_books_results
    recommended_books = get_recommend_books
    assert_equal true, recommended_books.include?(Book.find(3))
    assert recommended_books.find {|b| b == Book.find(3) }.recommendation_score > 0
  end
  
  def test_recommended_books_scores
    recommended_books = get_recommend_books
    assert_respond_to recommended_books[0], :recommendation_score
    assert recommended_books[0].recommendation_score > 0
  end
  
  def test_dataset
    use_dataset {
      MadeByMany::ActsAsRecommendable::Logic.module_eval do
        generate_dataset(User.aar_options) {|item, scores|
          Rails.cache.write("aar_#{User.aar_options[:on]}_#{item}", scores)
        }
      end
      recommended_books = get_recommend_books
      assert_equal true, recommended_books.include?(Book.find(3))
      assert recommended_books.find {|b| b == Book.find(3) }.recommendation_score > 0
    }
  end
  
  private
    def use_dataset
      User.aar_options[:use_dataset] = true
      yield
      User.aar_options[:use_dataset] = false
    end  
  
    def get_sim_users
      user = User.find(1)
      user.similar_users
    end
    
    def get_recommend_books
      user = User.find(2)
      user.recommended_books
    end
  
end