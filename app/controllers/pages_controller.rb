
class PagesController < ApplicationController

    def faq
      @active_link = "faq"
      @board = Board.faq
    end
    def privacy
      
    end


end
