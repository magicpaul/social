class QuizzesController < ApplicationController
  before_filter :authenticate_user!
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(params[:quiz])
    if @quiz.save
      redirect_to @quiz, notice: "Successfully created quiz."
    else
      render :new
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])
    if @quiz.update_attributes(params[:quiz])
      redirect_to @quiz, notice: "Successfully updated quiz."
    else
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy
    redirect_to quizzes_url, notice: "Successfully destroyed quiz."
  end

  def start
   @quiz = Quiz.find(params[:id])
   total = @quiz.questions.size
   all = @quiz.questions.find(:all).map {|x| x.id}
   session[:questions] = all.sort_by{rand}[0..(total-1)]

   session[:total]   = total
   session[:current] = 0
   session[:correct] = 0
   session[:score]   = 0
   redirect_to :action => "question"
  end

  def question
   @current  = session[:current]
   @total    = session[:total]
   @progress = (@current+1) * 100 / @total
   if @current >= @total
    redirect_to :action => "end"
    return
   end

   @question = Question.find(session[:questions][@current])
   @answers = @question.answers.sort_by{rand}

   session[:question] = @question
   session[:answers] = @answers
  end

  def answer
   @current = session[:current]
   @total   = session[:total]
   @progress = (@current+1) * 100 / @total
   answerid = params[:answer]

   @question = session[:question]
   @answers  = session[:answers]

   @answer = answerid ? Answer.find(answerid) : nil
   if @answer and @answer.correct
    @correct = true
    session[:correct] += 1
   else
    @correct = false
   end

   session[:current] += 1
  end

  def end
    @quiz = Quiz.find(params[:id])
    @correct = session[:correct]
    @total   = session[:total]
    @score = @correct * 100 / @total
    session[:score] = @score
  end
  def share
    @quiz = Quiz.find(params[:id])
    @score = session[:score]
    @badge = view_context.get_badge(@score)
    @url = start_quiz_path(@quiz)
    @content = "<span class='fi-trophy #{@badge} left'></span>I got #{@score}% in #{@quiz.name}!<br><br><a href='#{@url}'>Can you beat my score?</a>"
    @trophy = current_user.trophies.create(content: @content.html_safe)
    current_user.create_activity(@trophy, 'earned')
    redirect_to quizzes_url, notice: "Result shared."
  end
end