@IsTest
private class Account_Flow_Test {


    /**********
        Before Flow
    **********/

    @IsTest
    static void shouldAssignPriorityFromParentAccount() {
        Account parent = new Account(Name = 'Parent Account', Rating = 'Warm');
        insert parent;

        Account child = new Account(Name = 'Child Account', ParentId = parent.Id);
        Test.startTest();
        insert child;
        Test.stopTest();

        Account updatedChild = [SELECT Rating FROM Account WHERE Id = :child.Id];
        Assert.areEqual(parent.Rating, updatedChild.Rating, 'Rating should be copied from parent');
    }


    @IsTest
    static void testRatingUnchangedWhenParentHasNoRating() {
        Account parent = new Account(Name = 'Parent Account');
        insert parent;

        Account child = new Account(Name = 'Child Account', ParentId = parent.Id);
        Test.startTest();
        insert child;
        Test.stopTest();

        Account updatedChild = [SELECT Rating FROM Account WHERE Id = :child.Id];
        Assert.isNull(updatedChild.Rating, 'Rating should remain blank when Parent has no rating');
    }

    @IsTest
    static void shouldSetHotPriorityForPomorskieBillingState() {
        Account accountFromPomorskie = new Account(Name = 'Test Account', BillingState = 'Pomorskie');

        Test.startTest();
        insert accountFromPomorskie;
        Test.stopTest();

        Account updatedAcc = [SELECT Rating FROM Account WHERE Id = :accountFromPomorskie.Id];
        Assert.areEqual('Hot', updatedAcc.Rating, 'Rating should be set to Hot for Pomorskie state');
    }

    @IsTest
    static void shouldNotSetRatingForNonPomorskieBillingState() {
        Account accountNotFromPomorskie = new Account(Name = 'Test Account', BillingState = 'Other State');

        Test.startTest();
        insert accountNotFromPomorskie;
        Test.stopTest();

        Account updatedAcc = [SELECT Rating FROM Account WHERE Id = :accountNotFromPomorskie.Id];
        Assert.isNull(updatedAcc.Rating, 'Rating should remain blank for non-Pomorskie state');
    }


    /**********
        After Flow
    **********/
    @IsTest
    static void shouldAddWebsite() {
        Account accountEmptyWebsite = new Account(Name = 'Test Account');

        Test.startTest();
        insert accountEmptyWebsite;
        Test.stopTest();


        Account updatedAcc = [SELECT Website FROM Account WHERE Id = :accountEmptyWebsite.Id];
        Assert.areEqual('www.salesforce.com', updatedAcc.Website, 'Website should be filled');
    }

    @IsTest
    static void shouldCreateTaskWithPriorityBasedOnRating() {
        List<Account> accountsDifferentRatings = new List<Account>{
                new Account(Rating = 'Hot', Name = 'Test Hot'),
                new Account(Rating = 'Cold', Name = 'Test Cold')
        };

        Test.startTest();
        insert accountsDifferentRatings;
        Test.stopTest();


        List<Task> tasks = [SELECT Priority, WhatId FROM Task WHERE WhatId = :accountsDifferentRatings];
        Assert.areEqual(2, tasks.size(), 'Tasks should be created');
        Assert.areNotEqual(tasks[0].WhatId, tasks[1].WhatId, 'Each Tasks should be created for different Account');
        Assert.areNotEqual(tasks[0].Priority, tasks[1].Priority, 'Tasks Priority should depend on Account rating');
    }


}