class BoardsController < ApplicationController
    before_filter :require_admin, :except=>[:show]
    def show
      @board = Board.default
      @show_popup = params[:show_popup].present?
      if params[:id]
        @board = Board.find(params[:id])
      end
      @posts = @board.posts.finished.paginate(:page=>params[:page], :per_page=>10, :order=>"id desc")
    end
end
