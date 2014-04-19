class QuizResultsController < ApplicationController
    def new
      @quizresult = QuizResult.new
    end
    def create
      @quizresult = QuizResult.new(params[:quizresult])
    end
    def index
      @quizresult = QuizResult.all
    end
    def show
        @quiz = Quiz.find(params[:id])
        if @quiz
            @quiz_results = @quiz.quiz_results.all

            render action: :show
        else
            render file: 'public/404', status: 404, formats: [:html]
        end
    end
end