class ApplicationController < ActionController::API

    before_action :dateCompute, only: [:create, :update, :destroy]

    private
    def dateCompute

        require 'date'

        if params.key?(:eventstart) && params.key?(:eventend) && !params.key?(:duration)
            begin
                startDate = DateTime.parse(params[:eventstart])
                endDate = DateTime.parse(params[:eventend])
                if startDate < endDate
                    params[:duration] = (endDate - startDate).to_i
                else
                    render json: {:status => "error", :content => "Invalid start and end time"} and return
                end 
            rescue
                render json: {:status => "error", :content => "Invalid start or end date specified"}
            end
        elsif params.key?(:eventstart) && !params.key?(:eventend) && params.key?(:duration)
            begin
                params[:eventend] = DateTime.parse(params[:eventstart]).next_day(params[:duration].to_i).strftime("%Y-%m-%d %I:%M:%S")
            rescue
                render json: {:status => "error", :content => "Invalid start date or duration specified"}
            end
        elsif !params.key?(:eventstart) && params.key?(:eventend) && params.key?(:duration)
            begin
                endDate = DateTime.parse(params[:eventend])
                params[:eventstart] = (endDate - params[:duration].to_i).strftime("%Y-%m-%d %I:%M:%S")
            rescue
                render json: {:status => "error", :content => "Invalid end date or duration specified"} and return
            end
        end
    end

end
