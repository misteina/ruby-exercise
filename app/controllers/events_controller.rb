class EventsController < ApplicationController

    def index
        event = GroupEvent.all
        render json: {:status => "success", :content => event}
    end

    def create
        event = GroupEvent.new(event_params)
        if event.save
            render json: {:status => "success", :content => event}
        else
            render json: {:status => "error", :content => event.errors.full_messages}
        end
    end

    def show
        event = GroupEvent.find(params[:id])
        render json: {:status => "success", :content => event}
    end

    def update
        event = GroupEvent.find(params[:id])
        if event.update(event_params)
            render json: {:status => "success", :content => event}
        else
            render json: {:status => "error", :content => event.errors.full_messages}
        end
    end

    def destroy
        event = GroupEvent.find(params[:id])
        if event.update(status: "Deleted")
            render json: {:status => "success", :content => event}
        else
            render json: {:status => "error", :content => event.errors.full_messages}
        end
    end

    private

    def event_params
        params.permit(:name, :location, :description, :eventstart, :eventend, :duration, :status)
    end
    
end
