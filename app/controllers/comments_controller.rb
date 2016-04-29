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

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
      redirect_to @comment.post.board
    end


end
