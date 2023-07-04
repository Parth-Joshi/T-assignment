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
      message: "Successfully logged the #{params[:event_type]} event. Kindly find #{params[:event_type]} event_logs in data attributes",
      data: {
        event_logs: user.time_events.where(event_type: params[:event_type]).order('created_at DESC').map { |time_event| 
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
        message: "You are already following the user",
        data: {}
      }, status: 400
      return 
    end

    if params[:event_type] == 'unfollow' && follower.followed_users.find_by(followee: followee).blank?
      render json: {
        status_code: 400,
        message: "You are not following the user yet",
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

  def sleep_records_of_followers
    # API validations START
    error = ""
    error += "followee_id " if params[:followee_id].blank?
    
    if !error.blank?
      render json: {
        status_code: 400,
        message: 'Missing required parameters: ' + error,
        data: {}
      }, status: 400
      return
    end
    # API validations END

    followee = User.find(params[:followee_id])

    today_date = Date.today
    end_date = today_date - today_date.wday
    start_date = end_date - 6

    time_event_pairs = TimeEventPair.joins('left join time_events ON time_event_pairs.co_time_event_id = time_events.id').where(
      user: followee.followers).where('time_event_pairs.time_spent IS NOT NULL').where(
        time_events: { created_at: start_date..end_date }).includes(
          :user, :ci_time_event, :co_time_event).order('time_event_pairs.time_spent')

    render json: {
      status_code: 200,
      message: "List of sleep records of followers from previous week (#{start_date.strftime('%d-%m-%Y')} - #{end_date.strftime('%d-%m-%Y')})",
      data: time_event_pairs.map { |time_event_pair| 
        {
          user: time_event_pair.user.name,
          clock_in_at: time_event_pair.ci_time_event.created_at.strftime('%d-%m-%Y %H:%M:%S'),
          clock_out_at: time_event_pair.co_time_event.created_at.strftime('%d-%m-%Y %H:%M:%S'),
          sleep_time: ActiveSupport::Duration.build(time_event_pair.time_spent.to_i).inspect
        }
      }
    }, status: 200
    return
  end
end
