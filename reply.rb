require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class Reply

  def self.find_by_question_id(question_id)
   replies_data = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
     SELECT
       *
     FROM
       replies
     WHERE
       replies.question_id = :question_id
   SQL

   replies_data.map { |reply_data| Reply.new(reply_data) }
 end

 def self.find_by_user_id(user_id)
   replies_data = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
     SELECT
       *
     FROM
       replies
     WHERE
       replies.user_id = :user_id
   SQL

   replies_data.map { |reply_data| Reply.new(reply_data) }
 end


  attr_reader :id
  attr_accessor :question_id, :parent_reply, :user_id, :body

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply = options['parent_reply']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_user_id(@user_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_reply)
  end

  def child_reply
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply = @id
    SQL
    results.map { |datum| Reply.new(datum) }
  end
end
