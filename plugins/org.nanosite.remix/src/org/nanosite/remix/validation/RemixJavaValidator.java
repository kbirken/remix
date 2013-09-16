package org.nanosite.remix.validation;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ExtensibleURIConverterImpl;
import org.eclipse.xtext.validation.Check;
import org.nanosite.remix.remix.Collection;
import org.nanosite.remix.remix.Module;
import org.nanosite.remix.remix.RemixPackage;
 

public class RemixJavaValidator extends AbstractRemixJavaValidator {

	@Check
	public void checkModuleFile (Module module) {
		if (module.getFile().isEmpty()) {
			error("Please specify a valid filename", module, RemixPackage.eINSTANCE.getModule_File());
			return;
		}

		Collection collection = (Collection)module.eContainer();
		URI uri = null;
		if (collection.getPath()==null) {
			// collection without path specification, we check against local folder

			// get resource URI where module is located, remove the final part
			uri = module.eResource().getURI().trimSegments(1);
		} else {
			// collection with path specified, combine this with module's file
			uri = URI.createFileURI(collection.getPath());
			System.out.println("uri = " + uri.toString());
		}

		// construct URI for module file
		URI uri2 = uri.appendSegments(module.getFile().split("/"));
		
		ExtensibleURIConverterImpl conv = new ExtensibleURIConverterImpl();
		if (! conv.exists(uri2, null)) {
			error("File doesn't exist", module, RemixPackage.eINSTANCE.getModule_File());
		}
	}

}
