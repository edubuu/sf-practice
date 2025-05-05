trigger trg_opportunity on Opportunity (before update, before insert) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.handleBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}