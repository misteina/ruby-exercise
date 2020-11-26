class EventsController < ApplicationController

    def index
        event = GroupEvent.all
        render json: {:status => "success", :content => event}
    end

    def create
        event = GroupEvent.new(event_params)
        if event.save
            eventStatus = checkPublished(event)
            render json: {:status => "success", :content => eventStatus}
        else
            render json: {:status => "error", :content => "An error was encountered"}
        end
    end

    def show
        event = GroupEvent.find(params[:id])
        render json: {:status => "success", :content => event}
    end

    def update
        event = GroupEvent.find(params[:id])
        if event.update(event_params)
            eventStatus = checkPublished(event)
            render json: {:status => "success", :content => eventStatus}
        else
            render json: {:status => "error", :content => "An error was encountered"}
        end
    end

    def destroy
        event = GroupEvent.find(params[:id])
        if event.update(status: "Deleted")
            render json: {:status => "success", :content => event}
        else
            render json: {:status => "error", :content => "An error was encountered"}
        end
    end

    private

    def event_params
        params.permit(:name, :location, :description, :eventstart, :eventend, :duration, :status)
    end

    def checkPublished event
        status = "Published"
        event.attributes.each do |name, values|
            if !values
                status = "Draft"
                break  
            end
        end
        event.update(status: status)
        return event
    end
    
end
