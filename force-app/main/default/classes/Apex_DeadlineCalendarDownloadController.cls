public without sharing class Apex_DeadlineCalendarDownloadController {
    
    public FAFSA_Deadline__c FafsaDeadline {public get; private set;}
    public String FAFSA_DeadlineStr {public get; private set;}
    
    public integer DDDay{public get; private set;}
    public integer DDMonth{public get; private set;}
    public integer DDYear{public get; private set;}
    
    private final String statecode;

    // Default code to search for a FAFSA Deadline under if none is provided.  Assumed to be a 
    // search for Federal Fafsa Information
    private static final String DEFAULT_SEARCH_STATECODE = 'Fed';

    public Apex_DeadlineCalendarDownloadController(){
        statecode = ApexPages.currentPage().getParameters().get('scode');
        
        if(statecode == null) {
            statecode = DEFAULT_SEARCH_STATECODE;
        }

        List<FAFSA_Deadline__c> fafsaDeadlines = [SELECT     Calendar_URL__c,
                                    Deadline__c, 
                                    Deadline_Date__c, 
                                    Name, 
                                    State__c,
                                    State_Abbreviated__c 
                         FROM FAFSA_Deadline__c 
                         WHERE      State_Abbreviated__c =: statecode   OR
                                    State__c =: statecode
                         LIMIT 2];
    
            FafsaDeadline = (fafsaDeadlines != null && !fafsaDeadlines.isEmpty()) ? fafsaDeadlines[0] : null;
            
            if (FafsaDeadline != null) {
                DDDay = FafsaDeadline.Deadline_Date__c.day();
                DDMonth = FafsaDeadline.Deadline_Date__c.month();
                DDYear = FafsaDeadline.Deadline_Date__c.year();
                
                FAFSA_DeadlineStr =  FafsaDeadline.Deadline__c.replace('\n','');        
            } else {
                DDDay = null;
                DDMonth = null;
                DDYear = null;
                FAFSA_DeadlineStr = '';
            }
        
    }
}