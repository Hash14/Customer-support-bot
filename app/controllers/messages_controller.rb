class MessagesController < ApplicationController
	
	@PAT = 'EAAUq9k26EawBAM6tjrM8JopgqpZBcOvkfjZBsAJawfa7UL7uYxmosTxIXDwh6untVLLw44glPMFZCXq2fjpd0UVEimv0ZAhz4TnFPLz9R2Et5IWswSjrc7Aw4pfrIwZAGum2teOXZB2Fkw3oFT7MYXZBt86KLahOtbNAZCzNDAKG7wZDZD'

	def handle_verification
  puts "Handling Verification."
	  if request.args.get('hub.verify_token', '') == 'my_voice_is_my_password_verify_me'
	    puts "Verification successful!"
	    return request.args.get('hub.challenge', '')
	  else
	    puts "Verification failed!"
	    return 'Error, wrong validation token'
	  end
	end

	def handle_messages
  puts "Handling Messages"
  payload = request.get_data()
  puts payload
  for sender, message in messaging_events(payload)
    puts sender 
    puts message
    send_message(PAT, sender, message)
  return "ok"
	end


  def messaging_events(payload)
  # """Generate tuples of (sender_id, message_text) from the
  # provided payload.
  # """
  data = json.loads(payload)
  messaging_events = data["entry"][0]["messaging"]
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

  	r = requests.post("https://graph.facebook.com/v2.6/me/messages",
    params={"access_token": token},
    data=json.dumps({
      "recipient": {"id": recipient},
      "message": {"text": text.decode('unicode_escape')}
    }),
    headers={'Content-type': 'application/json'})
  	if r.status_code != requests.codes.ok
    	puts r.text
  	end
	end
	end

end
