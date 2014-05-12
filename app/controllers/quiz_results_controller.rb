class QuizResultsController < ApplicationController
    # New method
    def new
      # create a new empty result
      @quizresult = QuizResult.new
    end
    def create
      # take a passed quiz result and create a new result
      @quizresult = QuizResult.new(params[:quizresult])
    end
    def index
      # Display all quiz results (Never used)
      @quizresult = QuizResult.all
    end
    # Show quiz results for a specific quiz
    def show
        # get quiz from id and store in @quiz
        @quiz = Quiz.find(params[:id])
        # if @quiz exists
        if @quiz
            # show all quiz results for that quiz
            @quiz_results = @quiz.quiz_results.all
            render action: :show
        else
            # otherwise render 404
            render file: 'public/404', status: 404, formats: [:html]
        end
    end
end