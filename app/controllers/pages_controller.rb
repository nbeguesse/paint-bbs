
class PagesController < ApplicationController

    def faq
      @active_link = "faq"
      @faq = Board.faq
    end
    def privacy
      
    end


end
