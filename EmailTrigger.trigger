trigger EmailTrigger on Project__c (before update) {
    String newStatus = 'In Progress';
    for(Project__c p : trigger.new)
    {
        if(p.Status__c == newStatus){
            List<Messaging.SingleEmailMessage> emailList = new
                List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new
                Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'galitskaya.juliia@gmail.com'};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Email Trigger Task');
            mail.setPlainTextBody('Status of '+ p.Name + ' is changed to '+ '"' + newStatus + '".');
            emailList.add(mail);
            Messaging.SendEmailResult[] results =
                Messaging.sendEmail(emailList);
        }
    }
}