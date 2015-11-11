require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class Like

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = :id
    SQL

    results.map { |datum| Like.new(datum) }
  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = :question_id
    SQL

    results.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        COUNT(*)
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.id = :question_id
    SQL

    results.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = :user_id
    SQL

    results.map { |datum| Question.new(datum) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.question_id) DESC
      LIMIT :n
    SQL

    results.map { |datum| Question.new(datum) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
