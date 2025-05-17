trigger trg_contract on Contract (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        ContractTriggerHandler.handleAfterInsert(Trigger.new,Trigger.newMap);
    }
}