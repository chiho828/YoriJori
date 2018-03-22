class CommentsController < ApplicationController
    def create
        @comment = Comment.new
        @comment.content = params[:input_comment]
        
        @post = Post.find_by(yori_id: params[:yori_id])
        
        @comment.post_id = @post.id
        @comment.save
        
        redirect_to "/posts/show/#{params[:yori_id]}"
    end
    
    def destroy
        @comment = Comment.find(params[:comment_id])
        @comment.destroy
        redirect_to "/posts/show/#{params[:yori_id]}"
    end
end
