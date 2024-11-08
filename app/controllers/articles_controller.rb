class ArticlesController < ApplicationController

    def new
        @article = Article.new
    end

    def create
        @article = current_user.articles.build(article_params)
         if @article.save
          redirect_to @article, notice: 'Artículo creado exitosamente.'
        else
         render :new
        end
        
    end


    def show
        @article = Article.find(params[:id])
    end

    def index
        @articles = Article.all
    end

    def edit
        @article = Article.find(params[:id])
    end

    def update
        @article = Article.find(params[:id])
        if @article.update(article_params)
          redirect_to @article
           else
         render 'edit'
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
        redirect_to articles_path
    end

    before_action :authenticate_user!, only: [:new, :create]
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

 private
    def article_params
      params.require(:article).permit(:title, :text)
    end

    def set_article
        @article = Article.find(params[:id])
    end

    def authorize_user!
        unless @article.user == current_user
           redirect_to articles_path, alert: "No tienes permiso para realizar esta acción."
        end
    end
end 