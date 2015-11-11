require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class Follow

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.id = :id
    SQL
    results.map { |datum| Follow.new(datum) }
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows qf ON qf.user_id = users.id
      WHERE
        qf.question_id = :question_id
    SQL

    results.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        question_follows.*
      FROM
        users
      JOIN
        question_follows ON question_follows.user_id = users.id
      WHERE
        users.id = :user_id
    SQL

    results.map { |datum| Follow.new(datum) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
