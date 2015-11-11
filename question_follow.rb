require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class Follow

  def self.find_by_id(id)
    user_data = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_follows.id = :id
    SQL

    user_data.nil? ? nil : User.new(user_data)
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id, @user_id, @question_id = options.values_at('id', 'user_id', 'question_id')
  end

end
