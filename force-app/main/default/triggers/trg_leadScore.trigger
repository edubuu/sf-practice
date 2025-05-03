trigger trg_leadScore on Lead (after update, after insert) {
    if(Trigger.isAfter && Trigger.isUpdate){
        LeadTriggerHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }else if (Trigger.isAfter && Trigger.isInsert) {
        LeadTriggerHandler.handleAfterInsert(Trigger.newMap);
    }
}