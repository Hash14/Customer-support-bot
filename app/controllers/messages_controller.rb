class MessagesController < ApplicationController

  def handle_verification
    if params['hub.verify_token'] == 'my_voice_is_my_password_verify_guru'
      render json: params['hub.challenge']
    else
      return 'Error, wrong validation token'
    end
  end

  def handle_messages
    params["entry"].each do |entry|
      entry["messaging"].each do |messaging|
        sender_id = messaging["sender"]["id"]
        text = messaging["message"]["text"]
        send_message(sender_id , text)
      end
    end
    render json: {success: true}
  end

  def query_keywords
    { 
      jobs: ["job", "opening" , "vacancy" , "vacancies", "jobs"],
      abouts: ["product", "project", "app", "mobile", "idea", "ruby", "rails"],
      supports: ["support" , "talk", "support", "live"],
      welcomes: ["hai" ,"hello" , "hi", "hey" , "morning" , "afternoon", "morn" ],
      company: ["about", "hash14" , "company"],
      byes: ["bye" , "thanks", "thank you"],
      numbers: ["1","2","3","4","5","6","7","8","9","0"]
    }
  end
  
  def query_responses
    {
      jobs: "send your resume to magesh@hash14.com",
      abouts: "can you send details to sales@hash14.com",
      supports: "can you give as ur name and phone no",
      welcomes: "hey, how can i help you ?",
      byes: "bye, have a nice day",
      company: "We are a bunch of passionated and quality obsessed individuals who love getting their hands dirty playing with cutting edge technologies and providing solutions to challenging problems. We create, advise, and develop technology for startups and SME's. We help build your dreams on cloud, projecting the brand to a global level. vist http://www.hash14.com",
      numbers: "Thankyou , we will get back to you soon",
    }
  end
	
  def send_message(recipient, text)
    keywords = query_keywords
    responses = query_responses
    reply = nil

    keywords.each do |keyword_hash|
      if check_values_in_array(keyword_hash, text)
        reply = responses[keyword_hash.first]
        break
      end
    end
    post_to_facebook(recipient, reply)
  end

  def post_to_facebook(recipient, reply)
    body = {
     recipient: {
       id: recipient
     },
     message: {
       text: (reply.present? ? reply : "sorry i can't understand you :-(" )
     }
    }.to_json

    response = HTTParty.post(
     'https://graph.facebook.com/v2.6/me/messages?access_token='+APP_CONFIG['PAT'],
     body: body,
     headers: { 'Content-Type' => 'application/json' }
    )
	end

  def check_values_in_array(keyword_hash, text)
    keyword_hash.last.any? {|array_value| text.downcase.include? (array_value)}
  end
end