class Api::V1::EventsController < Api::V1::BaseController
  def create_time_event
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
      
    event_types = TimeEvent.event_types.keys

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

  def follow_unfollow_event
    # API validations START
    error = ""
    error += "follower_id " if params[:follower_id].blank?
    error += "followee_id " if params[:followee_id].blank?
    error += "event_type " if params[:event_type].blank?
    
    if !error.blank?
      render json: {
        status_code: 400,
        message: 'Missing required parameters: ' + error,
        data: {}
        }, status: 400
        return
      end
      
    event_types = ['follow', 'unfollow']

    if event_types.exclude? params[:event_type]
      render json: {
        status_code: 400,
        message: "Invalid event_type, Kindly pass #{event_types.join(' / ')} as event_type",
        data: {}
      }, status: 400
      return     
    end
    
    follower = User.find(params[:follower_id])
    followee = User.find(params[:followee_id])

    if follower == followee
      render json: {
        status_code: 400,
        message: "Operation not permitted on same user",
        data: {}
      }, status: 400
      return 
    end

    if params[:event_type] == 'follow' && followee.following_users.find_by(follower: follower).present?
      render json: {
        status_code: 400,
        message: "You have already followed the user",
        data: {}
      }, status: 400
      return 
    end

    if params[:event_type] == 'unfollow' && follower.followed_users.find_by(followee: followee).blank?
      render json: {
        status_code: 400,
        message: "You have not following the user yet",
        data: {}
      }, status: 400
      return 
    end
    # API validations END

    case params[:event_type]
    when 'follow'
      followee.followers << follower

    when 'unfollow'
      follower.followed_users.find_by(followee: 
        followee).destroy
    end

    render json: {
      status_code: 200,
      message: "Successfully logged the #{params[:event_type]} event",
      data: {}
    }, status: 200
    return
  end
end
