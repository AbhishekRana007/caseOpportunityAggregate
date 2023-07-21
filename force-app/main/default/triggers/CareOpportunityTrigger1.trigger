trigger CareOpportunityTrigger1 on Opportunity(after update,before update,before delete,after delete,before insert,after insert ){

    TriggerFactory.initiateHandler(Opportunity.sObjectType);
}