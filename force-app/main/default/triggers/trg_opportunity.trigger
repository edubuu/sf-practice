trigger trg_opportunity on Opportunity (before update, before insert) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.handleBeforeUpdate(Trigger.new);
        }else if (Trigger.isInsert) {
            OpportunityTriggerHandler.handleBeforeInsert(Trigger.new);  
        } 
    }else if(Trigger.isAfter){
        //Lógica para cuando el trigger se ejecute en After.
    }
}