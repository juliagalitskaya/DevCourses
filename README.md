# DevCourses

Tasks on Apex Trigger
1. Create an Apex trigger for Work Log to set the default Date as TODAY in case it is blank.

trigger DateTrigger1 on WorkLog__c (before insert) {

    for(WorkLog__c w : trigger.new)
    {
        if(w.Date__c == null){
            w.Date__c=system.today();
        }
    }     
}

2. Create an Apex trigger for Project which will send an email to Contact when Project
status is changed from “New” to “In Progress”.

trigger EmailTrigger on Project__c (before update) {
    String newStatus = 'In Progress';
    for(Project__c p : trigger.new)
    {
        if(p.Status__c == newStatus){
            // Prepare a list of emails to send
            List<Messaging.SingleEmailMessage> emailList = new
                List<Messaging.SingleEmailMessage>();
            
            // Collect list of emails
            Messaging.SingleEmailMessage mail = new
                Messaging.SingleEmailMessage();
            // List of emails or record Ids (User, Lead, Contact)
            String[] toAddresses = new String[] {'galitskaya.juliia@gmail.com'};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Email Trigger Task');
            mail.setPlainTextBody('Status of '+ p.Name + ' is changed to '+ '"' + newStatus + '".');
            emailList.add(mail);
            // Send emails
            Messaging.SendEmailResult[] results =
                Messaging.sendEmail(emailList);
        }
    }
}

3. Create an Apex trigger for the Project that does not allow to change Status of the Project
to “Closed” and does not allow to delete it in case if not all related Issues are “Done” or
“Cancelled”.

trigger ErrorTrigger on Project__c (before delete, before update) {
    for(Project__c p : trigger.new){
        for(Issue__c i :[SELECT Id, Status__c
                         FROM Issue__c]){
                             if (Trigger.isBefore && Trigger.isDelete) {
                                 if(i.Status__c != 'Done'||i.Status__c !='Cancelled'){
                                     p.adderror('You are not allowed to close or delete Project if at least one Issue is still open.');
                                 }
                             }
                             if (Trigger.isBefore && Trigger.isUpdate) {
                                 if(i.Status__c != 'Done'||i.Status__c !='Cancelled' && p.Status__c == 'Closed'){
                                     p.Status__c.adderror('You are not allowed to change status of the Project to "Closed"'
                                                          + ' until related issues are “Done” or “Cancelled”.');
                                 }
                             }
                         }
    }
}
