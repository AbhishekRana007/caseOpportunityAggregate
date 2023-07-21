@isTest
public class CareOpportunityTester1{
    @istest
    public static void test1(){

        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        Care__c cc = new Care__c();
        cc.Name = 'Care1';
        insert cc;

        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'New Opportunity';
        newOpportunity.StageName = 'Prospecting';
        newOpportunity.Care__c = cc.id;
        newOpportunity.Amount = 452555;
        newOpportunity.CloseDate = Date.today().addDays(30);
        insert newOpportunity;

        Opportunity newOpportunitys = [Select name, id, StageName
                                       from Opportunity];
        newOpportunitys.StageName = 'Closed Won';
        update newOpportunitys;
        Care__c NewCare = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                           from Care__c
                           Where name = 'Care1'];
        system.assertEquals(452555, NewCare.TotalOpportunityAmount__c);
        system.assertEquals(452555, NewCare.MinimumOpportunity__c);
        system.assertEquals(452555, NewCare.MaxOpportunityAmount__c);
        system.assertEquals(452555, NewCare.TotalOpportunityAverage__c);
    }

    @istest
    public static void test2(){

        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        Care__c cc = new Care__c();
        cc.Name = 'Care2';
        insert cc;

        LIST<opportunity> B = new LIST<opportunity>();

        for (integer i = 0; i < 20; i++){
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = 'New Opportunity' + i;
            newOpportunity.StageName = 'Prospecting';
            newOpportunity.Care__c = cc.id;
            newOpportunity.Amount = 452555+i;
            newOpportunity.CloseDate = Date.today().addDays(30);
            B.ADD(newOpportunity);
        }

        insert B;

        list<Opportunity> newOpportunitys = [Select name, id, StageName
                                             from Opportunity];
        for (Opportunity OO : newOpportunitys){
            OO.StageName = 'Closed Won';
        }
        update newOpportunitys;

        Care__c NewCare = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                           from Care__c
                           Where name = 'Care2'];
        Decimal x = NewCare.TotalOpportunityAmount__c;
        system.assertEquals(9051290, x);
        system.assertEquals(452555, NewCare.MinimumOpportunity__c);
        system.assertEquals(452574, NewCare.MaxOpportunityAmount__c);
        system.assertEquals(452564.5, NewCare.TotalOpportunityAverage__c);
    }

    @istest
    public static void test3(){

        TriggerConfig__c triggerConfig = new TriggerConfig__c();
        triggerConfig.Name = 'Opportunity';
        triggerConfig.IsActive__c = true;
        triggerConfig.ApexHandler__c = 'CareOpportunityHandler1';
        triggerConfig.SkipForUsers__c = null;
        insert triggerConfig;

        Care__c cc = new Care__c();
        cc.Name = 'Care3';
        insert cc;

        LIST<opportunity> B = new LIST<opportunity>();

        for (integer i = 0; i < 20; i++){
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = 'New Opportunity' + i;
            newOpportunity.StageName = 'Prospecting';
            newOpportunity.Care__c = cc.id;
            newOpportunity.Amount = 452555;
            newOpportunity.CloseDate = Date.today().addDays(30);
            B.ADD(newOpportunity);
        }

        insert B;

        list<Opportunity> newOpportunitys = [Select name, id, StageName
                                             from Opportunity];
        for (Opportunity OO : newOpportunitys){
            OO.StageName = 'Closed Lost';
        }
        update newOpportunitys;

        Care__c NewCare = [Select name, id, TotalOpportunityAmount__c, TotalOpportunityAverage__c, MinimumOpportunity__c, MaxOpportunityAmount__c
                           from Care__c
                           Where name = 'Care3'];
        system.assertEquals(null, NewCare.TotalOpportunityAmount__c);
        system.assertEquals(null, NewCare.MinimumOpportunity__c);
        system.assertEquals(null, NewCare.MaxOpportunityAmount__c);
        system.assertEquals(null, NewCare.TotalOpportunityAverage__c);
    }

}