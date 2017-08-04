@isTest
private class TestPostInstallClass {
	static testMethod void testCleanInstall() {		
		PostInstallClass postinstall = new PostInstallClass();
		Test.testInstall(postinstall, null);
		Settings__c result = Settings__c.getOrgDefaults();
		
		system.assertEquals('copado__', result.Namespace__c);
	}
	static testMethod void testUpgradeInstall() {
		Git_Repository__c g = new Git_Repository__c(name = 'g',Password__c = 'test');
		insert g;
		PostInstallClass postinstall = new PostInstallClass();
		Test.testInstall(postinstall, new Version(1,0), false);
		Settings__c result = Settings__c.getOrgDefaults();
		system.assertEquals('copado__', result.Namespace__c);
		system.assertNotEquals('test',[SELECT Password__c FROM Git_Repository__c WHERE Id=: g.Id LIMIT 1].Password__c);
	}

	static testMethod void testUpgradeInstallTwo() {
		Git_Repository__c g = new Git_Repository__c(name = 'g',Password__c = EncodingUtil.base64Encode(Blob.valueOf('test')));
		insert g;
		Personal_Settings__c s = new Personal_Settings__c(
			Name = 'test',
			API_Key__c = 'test'
		);
		insert s;
		PostInstallClass postinstall = new PostInstallClass();
		Test.testInstall(postinstall, new Version(8,40), false);
		Settings__c result = Settings__c.getOrgDefaults();
		system.assertEquals('copado__', result.Namespace__c);
		system.assertNotEquals('test',[SELECT Password__c FROM Git_Repository__c WHERE Id=: g.Id LIMIT 1].Password__c);
	}
}