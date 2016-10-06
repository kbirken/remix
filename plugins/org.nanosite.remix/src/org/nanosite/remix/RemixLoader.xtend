package org.nanosite.remix

import com.google.inject.Inject
import com.google.inject.Provider
import java.io.IOException
import java.util.Collections
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.nanosite.remix.remix.Model

class RemixLoader {

	@Inject Provider<ResourceSet> resourceSetProvider
	
	def load (String filename) {
		val resourceSet = resourceSetProvider.get
		try {
			val fileURI = URI::createURI(filename)
			val resource = resourceSet.getResource(fileURI, true)
			resource.load(Collections::EMPTY_MAP)
			return resource.contents.get(0) as Model
		} catch (IOException e) {
			e.printStackTrace
			return null
		}
	}
	
}
