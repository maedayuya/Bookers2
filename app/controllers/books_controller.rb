class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
  	@books = Book.page(params[:page]).reverse_order
  	@book = Book.new
  end

  def search
    @book = Book.new
    @books = Book.search(params[:model],params[:search_method],params[:search])
    @users = User.search(params[:model],params[:search_method],params[:search])
    new_history = current_user.search_histories.new(user_id: current_user.id,search: params[:search])
    if current_user.search_histories.exists?(search: params[:search])
      old_history = current_user.search_histories.find_by(search: params[:search])
      old_history.destroy
    end
    if params[:search] != ""
    new_history.save
    end
  end

  def history
    sort = params[:sort] || "created_at DESC"
    @histories = SearchHistory.where(user_id: current_user.id).order(sort)
  end

  def sort
    sort = params[:sort] || "created_at DESC"
    @histories = SearchHistory.where(user_id: current_user.id).order(sort)
    respond_to do |format|
    format.js {}
    end
  end

  def show
    @book_new = Book.new
  	@book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id

    respond_to do |format|
      if @book.save
        format.js {}
      else
        @books = Book.page(params[:page]).reverse_order
        format.html { render :index }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
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
