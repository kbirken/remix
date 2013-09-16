
package org.nanosite.remix;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class RemixStandaloneSetup extends RemixStandaloneSetupGenerated{

	public static void doSetup() {
		new RemixStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

