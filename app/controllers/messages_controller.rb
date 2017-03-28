class MessagesController < ApplicationController
	
	PAT = 'EAAUq9k26EawBAMJqvdqDuURTWC6hKgxIBbaUm5ZCZBZAq7yeJIG0ZBU59hCcSziFQBYjsprTiUJ5MaJKA5jF75ngI3ZChwhkhQv4qkZCyfPIZClsYQ0Yf11p7md02rpqoOZB3FFAiFUiEHZCZCELHTZBDeBS2oTZCke40n0KTxE1FJubyQZDZD'

	def handle_verification
  puts "Handling Verification."
  puts params['hub.verify_token']
  puts params['hub.challenge']
	  if params['hub.verify_token'] == 'my_voice_is_my_password_verify_guru'
	    puts "Verification successful!"
	    render json: params['hub.challenge']
	  else
	    puts "Verification failed!"
	    return 'Error, wrong validation token'
	  end
	end

	def handle_messages
  puts "Handling Messages"
  payload = params
  send_message(PAT, params['sender'] , params['message'])
  render json: payload

  # for sender, message in messaging_events(payload)
  #   puts sender 
  #   puts message
  #   send_message(PAT, sender, message)
  # return "ok"
	end


  def messaging_events(payload)
  # """Generate tuples of (sender_id, message_text) from the
  # provided payload.
  # """
  #data = json.loads(payload)
  #messaging_events = data["entry"][0]["messaging"]
  # for event in messaging_events
  #   if "message" in event and "text" in event["message"]
  #     yield event["sender"]["id"], event["message"]["text"].encode('unicode_escape')
  #   else
  #     yield event["sender"]["id"], "I can't echo this"
  #   end
  end

	def send_message(token, recipient, text)
  # """Send the message text to recipient with id recipient.
  # """
    uri = URI('https://graph.facebook.com/v2.8/me/messages')
  	r = Net::HTTP.post_form(uri,
    'params' => {"access_token": token},
    'data' => ({
      "recipient" => {"id": recipient},
      "message" => {"text": text}
    }), 'headers' => {'Content-type': 'application/json'})
    puts text
  	# if r.status_code != requests.codes.ok
   #  	puts r.text
  	# end
	end
end