require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'user'

class Question
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = :id
    SQL

    results.map { |datum| Question.new(datum) }
  end

  def self.find_by_author_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = :id
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    Follow.most_followed_questions(n)
  end

  def self.most_liked(n)
    Like.most_liked_questions(n)
  end

  attr_reader :id
  attr_accessor :title, :body, :user_id

  def initialize(options)
   @id = options['id']
   @title = options['title']
   @body = options['body']
   @user_id = options['user_id']
  end

  def author
    User.find_by_id(@user_id).first
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Follow.followers_for_question_id(@id)
  end

  def likers
    Like.likers_for_question_id(@id)
  end

  def num_likes
    Like.num_likes_for_question_id(@id)
  end
end
