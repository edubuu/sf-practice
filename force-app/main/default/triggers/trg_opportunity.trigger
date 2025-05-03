trigger trg_opportunity on Opportunity (before update, before insert) {
    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.handleBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }else if(Trigger.isBefore && Trigger.isInsert){
        OpportunityTriggerHandler.handleBeforeInsert(Trigger.newMap);
    }
}