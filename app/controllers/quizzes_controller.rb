class QuizzesController < ApplicationController
  # User can only take quiz if logged in
  before_filter :authenticate_user!

  ##########################
  #  Rails CRUD Functions  #
  ##########################

  # Controls the quiz index view
  def index
    # Instance variables are declared here so that can be used by the view
    # Get all quizzes from the database and store them in the @quizzes variable
    @quizzes = Quiz.all
    # Get all quiz results from the database and store them in @quizresult
    @quizresult = QuizResult.all
  end

  # Controls the show quiz view - this is not really used, but it's here.
  def show
    # Get the quiz by its id and store it in @quiz
    @quiz = Quiz.find(params[:id])
  end

  # Controls the new view.
  def new
    @quiz = Quiz.new
  end

  # Controls the create function.
  def create
    # Creates a new quiz
    @quiz = Quiz.new(params[:quiz])
    # If the quiz saves without error
    if @quiz.save
      # Redirect to the quiz (uses the show view) and display a message
      redirect_to @quiz, notice: "Successfully created quiz."
    else
      # Else try again.
      render :new
    end
  end

  # Controls the edit view
  def edit
    # Gets the quiz and stores it in @quiz
    @quiz = Quiz.find(params[:id])
  end

  # Conrols the update function
  def update
    # Get the quiz by its id and store it in @quiz
    @quiz = Quiz.find(params[:id])
    # If the quiz updates without error
    if @quiz.update_attributes(params[:quiz])
      # Redirect to the quiz (uses the show view) and display a message
      redirect_to @quiz, notice: "Successfully updated quiz."
    else
      # Else try again.
      render :edit
    end
  end
  # Controls the destroy function
  def destroy
    # Get quiz by id and store it as @quiz
    @quiz = Quiz.find(params[:id])
    # Destroy it
    @quiz.destroy
    # Redirect to index, display message
    redirect_to quizzes_url, notice: "Successfully destroyed quiz."
  end

  ##################
  # Quiz Functions #
  ##################

  # Controls the start function
  def start
    # Get quiz by id and store it as @quiz
    @quiz = Quiz.find(params[:id])
    # Get the quiz array length and set it as a variable. Note we're not using session variables because the view doesn't need to interact with the total yet.
    total = @quiz.questions.length
    # If total is greater than 10, set it to 10. Else leave it unchanged. This ensures we get a max of 10 questions but doesn't freak out if there's only 4.
    if total > 10
      total = 10
    end
    # Get all the questions in @quiz and store them in an array called all
    all = @quiz.questions.find(:all).map {|x| x.id}
    # Session variables: Thess will persist across multiple views
    # Get the all array, sort it by random, truncate it at 10 and save it to the questions session variable
    session[:questions] = all.sort_by{rand}[0..(total-1)]
    # Set the total session variable to total
    session[:total]   = total
    # Set current question to 0
    session[:current] = 0
    # Set number of correct answers to 0
    session[:correct] = 0
    # Set score to 0
    session[:score]   = 0
    # Redirect to question 1
    redirect_to :action => "question"
  end
  # Controls the question view
  def question
    # Get current question number and set it to instance variable @current.
    @current  = session[:current]
    # get total questions and set it to @total
    @total    = session[:total]
    # Calculate progress as a percentage
    @progress = (@current+1) * 100 / @total
    # If we're done, redirect to the end action
    if @current >= @total
      redirect_to :action => "end"
      return
    end
    # Get the question from the array at position @current, e.g. Question 4 gets item 4 in the array
    @question = Question.find(session[:questions][@current])
    # get the answers from the answers table for the question and sort them randomly
    @answers = @question.answers.sort_by{rand}
    # Set the session variables question and answers to @question and @answers so that they will be remembered on the answers view.
    session[:question] = @question
    session[:answers] = @answers
  end

  # Controls the feedback view
  def answer
    # Get current question number and set it to instance variable @current.
    @current = session[:current]
    # get total questions and set it to @total
    @total   = session[:total]
    # Calculate progress as a percentage
    @progress = (@current+1) * 100 / @total
    # Get the user's answer passed via HTTP
    answerid = params[:answer]
    # Get the question and answer session variables
    @question = session[:question]
    @answers  = session[:answers]
    # Set @answer to answerid if it's not nil
    @answer = answerid ? Answer.find(answerid) : nil
    # If it's not nil and it is correct...
    if @answer and @answer.correct
      # set @correct to true
      @correct = true
      # and increment the total of correct answers
      session[:correct] += 1
    else
      # otherwise set @ correct to false
      @correct = false
    end
    # increment the current question
    session[:current] += 1
  end
  # Controls the end quiz view
  def end
    # Get quiz by id and store it as @quiz
    @quiz = Quiz.find(params[:id])
    # Get the number of correct answers and store it as @correct
    @correct = session[:correct]
    # Get the total number of questions and store it as @total
    @total   = session[:total]
    # Calculate the score as a percentage
    @score = @correct * 100 / @total
    # Call get_points passing the score variable to get the number of points earned
    @points = get_points(@score)
    # get current user and set them as @user
    @user = current_user
    # Give the user some points
    current_user.add_points(@points, category: 'Quizzes')
    # Set @next to false
    @next = false
    # if the score is high enough to unlock the next quiz...
    if @score > 75
      # set next to true.
      @next = true
    end
    # Create a Quiz Result
    @quizresult = QuizResult.create(user_id: @user.id, quiz_id: @quiz.id, score: @score, next_quiz: @next )
    # Set the session variable score to @score so that we can call the share function
    session[:score] = @score
  end

  # Caluculate the trophy classification
  def get_points(score)
    case
        # If score is greater than 75, give 30 points
        when score > 75
            return 30
        # If it's greater than 50, give 20 points
        when score > 50
            return 20
        # Otherwise give 10. Fun Revision loves a trier.
        else
            return 10
    end
  end
  # Controls the share functions
  def share
    # Get the quiz by id and store it in @quiz
    @quiz = Quiz.find(params[:id])
    # Get the current score and store it in @score
    @score = session[:score]
    # Call the get_badge helper passing the @score variable. Set the resulting string (gold, silver, bronze) as @badge
    @badge = view_context.get_badge(@score)
    # Get the quiz path and set it as @url
    @url = start_quiz_path(@quiz)
    # Spoilers. Sharing a result is really just creating a specifically formatted status. Things were going to get too complicated otherwise with polymorphic associations and nonsense like that. Set the status content as a string using the previously defined variables.
    @content = "<span class='fi-trophy #{@badge} left'></span>I got #{@score}% in #{@quiz.name}!<br><br><a href='#{@url}' data-method='post'>Can you beat my score?</a>"
    # Create a status.
    @trophy = current_user.statuses.create(content: @content.html_safe)
    # Create an activity with the action earned. This will appear in the activity feed as "User Name earned a trophy"
    current_user.create_activity(@trophy, 'earned')
    # redirect to the quiz index with a notice. Phew.
    redirect_to quizzes_url, notice: "Result shared."
  end
end