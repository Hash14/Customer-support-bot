class MessagesController < ApplicationController
	
	PAT = 'EAAUq9k26EawBAMJqvdqDuURTWC6hKgxIBbaUm5ZCZBZAq7yeJIG0ZBU59hCcSziFQBYjsprTiUJ5MaJKA5jF75ngI3ZChwhkhQv4qkZCyfPIZClsYQ0Yf11p7md02rpqoOZB3FFAiFUiEHZCZCELHTZBDeBS2oTZCke40n0KTxE1FJubyQZDZD'

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
        send_message(PAT, sender_id , text)
      end
    end
    render json: {success: true}
  end

	def send_message(token, recipient, text)
  # """Send the message text to recipient with id recipient.
  # """
  keywords = {
    welcomes: ["hai" ,"hello" , "hi", "hey" , "morning" , "afternoon", "morn" ],
    jobs: ["job", "opening" , "vacancy" , "vacancies", "jobs"],
    abouts: ["product", "project", "app", "mobile", "idea", "ruby", "rails"],
    supports: ["support" , "talk", "support", "live"],
    company: ["about", "hash14" , "you", "company"],
    byes: ["bye" , "thanks", "thank you"],
    numbers: ["1","2","3","4","5","6","7","8","9","0"]
  }

  responses = {
    jobs: "send your resume to magesh@hash14.com",
    abouts: "can you send details to sales@hash14.com",
    supports: "can you give as ur name and phone no",
    welcomes: "hey, how can i help you ?",
    byes: "bye, have a nice day",
    company: "We are a bunch of passionated and quality obsessed individuals who love getting their hands dirty playing with cutting edge technologies and providing solutions to challenging problems. We create, advise, and develop technology for startups and SME's. We help build your dreams on cloud, projecting the brand to a global level. vist http://www.hash14.com",
    numbers: "Thankyou , we will get back to you soon",
  }

  keywords.each do |keyword_hash|
    if check_values_in_array(keyword_hash, text)
      reply = responses[keyword_hash.first.to_sym]
      return reply
    end
  end
    # if check_values_in_array(jobs, text)
    #   reply = "send your resume to magesh@hash14.com"
    # elsif abouts.any? { |about| text.downcase.include?(about) }
    #   reply = "can you send details to sales@hash14.com"
    # elsif supports.any? { |support| text.downcase.include?(support) } 
    #   reply = "can you give as ur name and phone no"
    # elsif welcomes.any? { |welcome| text.downcase.include?(welcome) }
    #   reply = "hey, how can i help you ?"
    # elsif byes.any? { |bye| text.downcase.include?(bye) }
    #   reply = "bye, have a nice day"
    # elsif company.any? {|comp| text.downcase.include?(comp)}
    #   reply = "We are a bunch of passionated and quality obsessed individuals who love getting their hands dirty playing with cutting edge technologies and providing solutions to challenging problems. We create, advise, and develop technology for startups and SME's. We help build your dreams on cloud, projecting the brand to a global level. vist http://www.hash14.com"  
    # elsif numbers.any? {|number| text.downcase.include?(number)} 
    #   reply = "Thankyou , we will get back to you soon"
    # else
    #   reply = "sorry i can't understand you :-(" 
    # end
    body = {
     recipient: {
       id: recipient
     },
     message: {
       text: (reply.present? ? reply : "sorry i can't understand you :-(")
     }
    }.to_json
    response = HTTParty.post(
     'https://graph.facebook.com/v2.6/me/messages?access_token=EAAUq9k26EawBAMJqvdqDuURTWC6hKgxIBbaUm5ZCZBZAq7yeJIG0ZBU59hCcSziFQBYjsprTiUJ5MaJKA5jF75ngI3ZChwhkhQv4qkZCyfPIZClsYQ0Yf11p7md02rpqoOZB3FFAiFUiEHZCZCELHTZBDeBS2oTZCke40n0KTxE1FJubyQZDZD',
     body: body,
     headers: { 'Content-Type' => 'application/json' }
    )
     puts response.inspect
	end

  def check_values_in_array(keyword_hash, text)
    keyword_hash.last.any? {|array_value| text.downcase.include? (array_value)}
  end
end