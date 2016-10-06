package org.nanosite.remix.tests

import com.google.inject.Injector
import org.junit.Before
import org.junit.Test
import org.nanosite.remix.RemixLoader
import org.nanosite.remix.RemixStandaloneSetup
import org.nanosite.remix.generator.RemixGenerator

import static org.junit.Assert.*
import org.eclipse.xtext.generator.InMemoryFileSystemAccess

class RemixTests {
	
	var Injector injector

	@Before
	def void setUp() throws Exception {
		injector = new RemixStandaloneSetup().createInjectorAndDoEMFRegistration
	}

	@Test
	def void testGenerator1() {
		val rmx = "models/CodeSection/code_section.rmx"

		testGen(rmx)
	}

	def private testGen(String rmx) {
		val loader = injector.getInstance(typeof(RemixLoader))
		val model = loader.load(rmx)
		assertNotNull(model)
		assertEquals(1, model.presentations.size)
		assertNotNull(model.presentations.head.target)

		// create dummy FileSystemAccess object, will not be used by generator		
		val fsa = new InMemoryFileSystemAccess

		val generator = injector.getInstance(typeof(RemixGenerator))
		generator.doGenerate(model.eResource, fsa)		

		// check output file against expected reference files
		println("target: " + model.presentations.head.target)
	}

}
