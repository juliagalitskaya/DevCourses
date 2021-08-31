trigger DateTrigger1 on WorkLog__c (before insert) {

    for(WorkLog__c w : trigger.new)
    {
        if(w.Date__c == null){
            w.Date__c=system.today();
        }
    }     
}