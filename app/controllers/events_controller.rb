class EventsController < ApplicationController

    def index
        @event = GroupEvent.all
    end

    def create
        @event = GroupEvent.new(event_params)
        @event.save
        if @article.save
            redirect_to @article
        else
            render 'new'
        end
    end

    def show
        @event = GroupEvent.find(params[:id])
    end

    def update
        @event = GroupEvent.find(params[:id])
        if @event.update(event_params)
            # json success
        else
            # json success
        end
    end

    def destroy
        @event = GroupEvent.find(params[:id])
        @event.destroy
    end

    private
        def event_params
            params.require(:event).permit(:name, :location, :description)
        end
    
end
