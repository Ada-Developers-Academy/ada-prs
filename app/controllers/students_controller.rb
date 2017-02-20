class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(stud_params)

    if @student.save
      redirect_to students_path
    else
      render :new, :status => :bad_request
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.update(params[:id], stud_params)
    if @student.errors.any?
      render :edit, :status => :bad_request
    else
      redirect_to students_path
    end
  end

  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy
    redirect_to students_path
  end

  private

  def stud_params
   params.require(:student).permit(:name, :cohort_id, :github_name, :email)
  end
end
