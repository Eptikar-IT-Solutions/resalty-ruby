class CheckMessageStatus
  include Sidekiq::Worker
  def perform    
      status = resalty.status(messageID)

      if(status[status_number] == 5 || status[status_number] == 1)
         Message.find(messageID).status_number = status[status_number]
      else
         Message.find(messageID).status_number = status[status_number]
         self.class.perform_in(30.seconds, messageID)
  end
end