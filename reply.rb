require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class Reply

  def self.find_by_question_id(question_id)
   replies_data = QuestionsDatabase.execute(<<-SQL, question_id: question_id)
     SELECT
       replies.*
     FROM
       replies
     WHERE
       replies.question_id = :question_id
   SQL

   replies_data.map { |reply_data| Reply.new(reply_data) }
 end

 def self.find_by_user_id(user_id)
   replies_data = QuestionsDatabase.execute(<<-SQL, user_id: user_id)
     SELECT
       replies.*
     FROM
       replies
     WHERE
       replies.author_id = :user_id
   SQL

   replies_data.map { |reply_data| Reply.new(reply_data) }
 end


  attr_reader :id
  attr_accessor :question_id, :parent_reply, :user_id, :body

  def initialize(options)
    @id, @question_id, @parent_reply, @user_id, @body =
      options.values_at(
        'id', 'question_id', 'parent_reply', 'user_id', 'body'
      )
  end



end
