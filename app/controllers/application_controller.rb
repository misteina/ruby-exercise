class ApplicationController < ActionController::API

    before_action :dateCompute

    private
    def dateCompute

        methods = ["POST", "PUT", "PATCH"]

        if methods.include? request.method
            require 'date'

            fields = ["name", "location", "description", "eventstart", "eventend", "duration"]

            params[:status] = 'Published'
            fields.each { |item|
                if !params.key?(item)
                    params[:status] = 'Draft'
                end
            }

            case params
            when !params.key?(:eventstart) && !params.key?(:eventend) && params.key?(:duration)
                begin
                    startDate = DateTime.parse(params[:eventstart])
                    endDate = DateTime.parse(params[:eventend])
                    params[:duration] = (endDate - startDate).to_i
                rescue
                    render json: {:status => "error", :content => "Invalid start or end date specified"}
                end
            when !params.key?(:eventstart) && params.key?(:eventend) && !params.key?(:duration)
                begin
                    startDate = DateTime.parse(params[:eventstart])
                    params[:eventend] = DateTime.parse(params[:eventstart]).next_day(duration)
                rescue
                    render json: {:status => "error", :content => "Invalid start date or duration specified"}
                end
            when params.key?(:eventstart) && !params.key?(:eventend) && !params.key?(:duration)
                begin
                    endDate = DateTime.parse(params[:eventend])
                    params[:eventstart] = (endDate.to_s - params[:duration])
                rescue
                    render json: {:status => "error", :content => "Invalid end date or duration specified"}
                end
            end
        end
    end
end
