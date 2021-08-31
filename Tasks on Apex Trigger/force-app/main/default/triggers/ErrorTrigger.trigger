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