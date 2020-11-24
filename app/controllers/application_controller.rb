class ApplicationController < ActionController::API

    before_action :dateCompute

    private
    def dateCompute

        methods = ["POST", "PUT", "PATCH"]

        if methods.include? request.method
            require 'date'

            fields = ["name", "location", "description", "start", "end", "duration"]

            fields.each { |item|
                if !params.key?(item)
                    params[:status] = "Draft"
                    break
                else
                    params[:status] = "Published"
                end
            }

            case params
            when !params[:start].empty? && !params[:end].empty? && params[:duration].empty?
                begin
                    startDate = DateTime.parse(params[:start])
                    endDate = DateTime.parse(params[:end])
                    params[:duration] = (endDate - startDate).to_i
                rescue
                    render json: {:status => "error", :content => "Invalid start or end date specified"}
                end
            when !params[:start].empty? && params[:end].empty? && !params[:duration].empty?
                begin
                    startDate = DateTime.parse(params[:start])
                    params[:end] = DateTime.parse(params[:start]).next_day(duration)
                rescue
                    render json: {:status => "error", :content => "Invalid start date or duration specified"}
                end
            when params[:start].empty? && !params[:end].empty? && !params[:duration].empty?
                begin
                    endDate = DateTime.parse(params[:end])
                    params[:start] = (endDate.to_s - params[:duration])
                rescue
                    render json: {:status => "error", :content => "Invalid end date or duration specified"}
                end
            end
        end
    end
end
