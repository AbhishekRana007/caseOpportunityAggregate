public with sharing class CareOpportunityHelper1{
    private static List<AggregateResult> aggregateResults;
    private static set<id> ids = new set<id>();
    private static map<id, AggregateResult> Aggregatemap = new Map<id, AggregateResult>();
    
    public static void SoqlFetcher(list<Opportunity> opportunityList){

        for (Opportunity acc : opportunityList){
            if (acc.Care__c != null){
                ids.add(acc.Care__c);
            }
        }
        aggregateResults = [select sum(amount)sum, avg(amount)avg, max(amount)max, min(amount)min, Care__c
                            from Opportunity
                            where Care__c in:ids and StageName = 'Closed Won'
                            group by Care__c];
        if (!aggregateResults.isEmpty()){


            Mapper();
        }
    }

    public static void Mapper(){

        for (AggregateResult result : aggregateResults){
            ID CareId = (Id) result.get('Care__c');
            Aggregatemap.put(CareId, result);
        }
    }

    public static void CareUpdater(){
        if (!Aggregatemap.isEmpty()){
            List<Care__c> CareUpdater = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                                         from Care__c
                                         where id in:ids];
            for (Care__c accs : CareUpdater){
                aggregateResult OneAggregate = Aggregatemap.get(accs.id);
                accs.TotalOpportunityAmount__c = (Decimal) OneAggregate.get('sum');
                accs.TotalOpportunityAverage__c = (Decimal) OneAggregate.get('avg');
                accs.MinimumOpportunity__c = (Decimal) OneAggregate.get('min');
                accs.MaxOpportunityAmount__c = (Decimal) OneAggregate.get('max');
            }

            // system.debug(acc[0].TotalOpportunityAmount__c);
            if (!CareUpdater.isEmpty()){
                update CareUpdater;
            }
        }
    }

}