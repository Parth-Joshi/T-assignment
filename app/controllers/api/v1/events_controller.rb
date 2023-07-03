class Api::V1::EventsController < Api::V1::BaseController
  def create_time_event
    event_types = TimeEvent.event_types.keys

    # API validations START
    error = ""
    error += "current_user_id " if params[:current_user_id].blank?
    error += "event_type " if params[:event_type].blank?

    if !error.blank?
      render json: {
        status_code: 400,
        message: 'Missing required parameters: ' + error,
        data: {}
      }, status: 400
      return
    end

    if event_types.exclude? params[:event_type]
      render json: {
        status_code: 400,
        message: "Invalid event_type, Kindly pass #{event_types.join(' / ')} as event_type",
        data: {}
      }, status: 400
      return     
    end

    user = User.find(params[:current_user_id])

    if params[:event_type] == 'clock_in' && (user.time_events.present? && 
      !user.time_events.last.clock_out?)
      render json: {
        status_code: 400,
        message: "Not able to clock_in, Kindly Clock OUT first",
        data: {}
      }, status: 400
      return 
    end
    
    if params[:event_type] == 'clock_out' && !user.time_events.last&.clock_in?
      render json: {
        status_code: 400,
        message: "Not able to clock_out, Kindly Clock IN first",
        data: {}
      }, status: 400
      return 
    end
    # API validations END

    TimeEvent.create(user: user, event_type: params[:event_type])
    
    render json: {
      status_code: 200,
      message: "Successfully logged the #{params[:event_type]} event",
      data: {
        event_logs: user.time_events.order('created_at DESC').map { |time_event| 
          time_event.created_at.strftime('%d-%m-%Y %H:%M:%S')
        }
      }
    }, status: 200
    return
  end
end
