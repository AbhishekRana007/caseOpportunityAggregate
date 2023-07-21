trigger CareOpportunityTrigger1 on Opportunity(after update ){

    TriggerFactory.initiateHandler(Opportunity.sObjectType);
}