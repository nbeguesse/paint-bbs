class PostsController < InheritedResources::Base
    protect_from_forgery :except => [:save]
    before_filter :get_post, :only=>[:new, :edit, :doodle, :save, :show]
    before_filter :get_board
    before_filter :require_post, :only=>[:new, :edit, :show]
    before_filter :require_user, :only=>[:upload, :create]
    before_filter :may_edit_post, :only=>[:doodle, :destroy, :edit, :update]

    def show

      @title = @post.title
    end

    #To reach, click "Doodle" or "Continue"
    def doodle
      @paint = {
        :saveUrl => saveUrl,
        :postUrl => postUrl
      }
      if @post
        @paint[:loadImageUrl] = @post.load_image_url
        @paint[:loadChibiFileUrl] = @post.load_chibi_file_url
        @paint[:loadSwatchesUrl] = @post.load_swatches_url
        @paint[:rotation] = @post.rotation
      else
        @paint[:canvasWidth] = params[:width] || Settings.canvas.default_height
        @paint[:canvasHeight] = params[:height] || Settings.canvas.default_width
      end
      render :layout=>nil
    end


    #To reach, click on "Save" in ChickenPaint
    def save #always post
      #TODO: don't let people overwrite others' posts by changing the URL
      @post ||= generate_post(@user, {
        :paint_time=>0, 
        :in_progress=>true})
      #overwrite work in progress
      if params[:started_at] && @post.paint_time.present?
        @post.paint_time += Time.now.to_i - params[:started_at].to_i
      else
        @post.paint_time = nil
      end
      @post.image = params[:picture]
      @post.anim = params[:chibifile]
      @post.palette = params[:swatches]
      @post.rotation = params[:rotation]
      @post.save!
      
      #save and continue drawing option
      render :text=>"CHIBIOK\n" and return
    end


    #to reach, click "Upload" in menu
    def upload
      @active_link = "upload"
      @post = generate_post(current_user, {:is_upload=>true})
      render :new
    end

    #To reach, click "Upload" then the submit button
    def create
      @active_link = "upload"
      params[:post][:is_upload] = true
      @post = generate_post(current_user, params[:post])
      if @post.save
        flash[:notice] = "You made a new post!"
        redirect_to board_path(@board)
      else
        flash[:error] = @post.errors.full_messages.first
        render :new
      end
    end

    #To reach, click the submit button when posting art or editing message
    def update
      @active_link = "doodle"
      @post = Post.find(params[:id])
      #mark the post finished and run validations
      @post.in_progress = false
      if @post.update_attributes(params[:post])
        flash[:notice] = "Hooray!"
        redirect_to board_path(@board)
      else
        flash[:error] = @post.errors.full_messages.first
        render :edit
      end
    end


private
    def get_board
      @board = @post.try(:board) || Board.find_by_id(params[:board_id]) || Board.default
    end

    def get_post
      @user = session_obj
      if params[:id]
        @post = Post.find(params[:id])
      elsif params[:slug]
        @post = Post.find_by_slug(params[:slug])
      else
        @post = @user.work_in_progress
      end
    end
    def require_post
      unless @post
        flash[:error] = "That post was deleted."
        redirect_to board_path(@board)
      end
    end

  def saveUrl
    params = {:started_at=>Time.now.to_i}
    if @post
      if @post.is_upload?
        #i.e. continuing a static image
        params.except! :started_at
      end
      if @post.id && params[:new_slot].blank?
        #i.e. editing a finished post
        params[:id]=@post.id
      end
    end
    return save_board_posts_path(params)
  end

  def postUrl
    if @post && params[:new_slot].blank?
      return edit_post_path(@post)
    end
    return new_post_path

  end
    
end
