class CommentsController < ApplicationController
    def create
        @comment = Comment.new
        @comment.content = params[:input_comment]
        @comment.user_id = current_user.id
        @comment.username = current_user.username
        
        @post = Post.find_by(yori_id: params[:yori_id])
        
        
        @comment.post_id = @post.id
        @comment.save
        
        redirect_to "/yojo/yori/#{params[:yori_id]}"
    end
    
    def destroy
        @comment = Comment.find(params[:comment_id])
        @comment.destroy
        redirect_to "/yojo/yori/#{params[:yori_id]}"
    end
end
