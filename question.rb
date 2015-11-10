require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'user'

class Question
  def self.find_by_id(id)
    user_data = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        users.*
      FROM
        users
      WHERE
        users.id = :id
    SQL

    user_data.nil? ? nil : User.new(user_data)
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

  attr_reader :id
  attr_accessor :title, :body, :author_id

  def initialize(options)
   @id, @title, @body, @author_id =
     options.values_at('id', 'title', 'body', 'author_id')
  end
end
