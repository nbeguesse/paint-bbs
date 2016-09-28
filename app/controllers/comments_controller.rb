class CommentsController < InheritedResources::Base
    before_filter :may_edit_comment, :only=>[:edit, :update]
    before_filter :may_delete_comment, :only=>[:destroy]
    def new
      @post = Post.find(params[:post_id])
      @comment = generate_comment(session_obj)
    end

    def create
      @post = Post.find(params[:post_id])
      @comment = generate_comment(session_obj, params[:comment])
      if @comment.save
        flash[:notice] = "Thanks! You just brightened someone's day!"
        redirect_to @comment.post.board
      else
        flash[:error] = @comment.errors.full_messages.first
        render :new
      end
    end

    def update
      @comment = Comment.find(params[:id])
      @post = @comment.post
      if @comment.update_attributes(params[:comment])
        redirect_to @comment.post.board
      else
        flash[:error] = @comment.errors.full_messages.first
        render :edit
      end
    end
private
  def may_edit_comment
    if @comment = Comment.find(params[:id])
      unless (current_user && current_user.may_edit_comment?(@comment))
        flash[:error] = "Please login as a moderator to do that."
        redirect_to new_user_url
      end
    end
  end

  def may_delete_comment
    if @comment = Comment.find(params[:id])
      unless (current_user && current_user.may_delete_comment?(@comment))
        flash[:error] = "Please login as a moderator to do that."
        redirect_to new_user_url
      end
    end
  end


end
