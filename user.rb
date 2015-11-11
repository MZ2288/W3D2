require_relative 'question'
require_relative 'questions_database'
require_relative 'question_follow'

class User
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = :id
    SQL

    results.map { |datum| User.new(datum) }
  end

  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = :fname AND users.lname = :lname
    SQL

    results.map { |datum| User.new(datum) }
  end

  attr_reader :id
  attr_accessor :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.user_id = @id

    SQL

    results.map { |datum| Question.new(datum) }
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    Follow.followed_questions_for_user_id(@id)
  end
end
