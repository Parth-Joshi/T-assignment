# README
Assignment details:

Candidate Name: Parth Joshi

Rails version: 7.0.6  
Ruby version: ruby 3.0.5p211 (2022-11-24 revision ba5cf0f7c5 [x86_64-linux]  
DB used: postgres

Attached postman collection for ready reference

Features implemented:
- Database level foreign key constraint
- Multi level validations in API along with proper response codes
- Model Relationships
- Eager loading

Branch on github: main

To run project:
- cd to project path
- bundle install
- rake db:create
- rake db:migrate
- rake db:seed
- rails s

Please view postman collection

# API details:
## API 1:
To Clock IN / Clock OUT user  

URL: localhost:3000/api/v1/create_time_event  
METHOD TYPE: POST  
Request params:
- current_user_id - required
- event_type (valid entries: clock_in / clock_out) - required

Response:  
Success response:  
``` 
  {
    "status_code": 200,
    "message": "Successfully logged the clock_in event. Kindly find clock_in event_logs in data attributes",
    "data": {
        "event_logs": [
            "04-07-2023 09:05:36"
        ]
    }
}
```

## API 2:
To follow / unfollow user  

URL: localhost:3000/api/v1/follow_unfollow_event  
METHOD TYPE: POST  
Request params:  
- follower_id - required
- followee_id - required
- event_type (valid entries: follow / unfollow) - required

Response:  
Success response:  
```  
  {
      "status_code": 200,
      "message": "Successfully logged the follow event",
      "data": {}
  }
```

## API 3:  
To get sleep record of followers from prevoius week  

URL: localhost:3000/api/v1/get_sleep_records_of_followers  
METHOD TYPE: GET  
Request params:
- followee_id - required

Response:  
Success response:  
```
  {
    "status_code": 200,
    "message": "List of sleep records of followers from previous week (26-06-2023 - 02-07-2023)",
    "data": [
        {
            "user": "User 1",
            "clock_in_at": "28-06-2023 08:45:28",
            "clock_out_at": "28-06-2023 08:46:06",
            "sleep_time": "37 seconds"
        },
        {
            "user": "User 1",
            "clock_in_at": "28-06-2023 08:46:34",
            "clock_out_at": "28-06-2023 08:47:53",
            "sleep_time": "1 minute and 19 seconds"
        }
    ]
}
```