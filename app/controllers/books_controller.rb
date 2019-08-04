class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
  	@books = Book.all
  	@book = Book.new
  end

  def show
    @book_new = Book.new
  	@book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id
  	if @book.save
  		flash[:notice] = "Book was successfully created."
  	  redirect_to book_path(@book)
    else
      @books = Book.all
      render 'books/index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		flash[:notice] = "Book was successfully updated."
    	redirect_to book_path(@book)
    else
      render :edit
  	end
  end

  def destroy
  	book = Book.find(params[:id])
  	book.destroy
  	if book.destroy
  		flash[:notice] = "Book was successfully destroyed."
  	end
  	redirect_to user_path(current_user)
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    if current_user != @book.user
      redirect_to books_path
    end
  end

end
