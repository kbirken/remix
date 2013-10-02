/*
 * generated by Xtext
 */
package org.nanosite.remix.generator

import java.io.BufferedReader
import java.io.File
import java.io.FileNotFoundException
import java.io.FileReader
import java.io.IOException
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.common.CommonPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.nanosite.remix.remix.Collection
import org.nanosite.remix.remix.Model
import org.nanosite.remix.remix.Module
import org.nanosite.remix.remix.Part
import org.nanosite.remix.remix.Presentation
import org.nanosite.remix.remix.DependencyType

class RemixGenerator implements IGenerator {
	
	static final String RESOURCE_FOLDER = "resources" 

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		println("RemixGenerator running...")
		for(m : resource.allContents.toIterable.filter(typeof(Model))) {
//			var filebase = resource.URI.segments.last
//			var dotfile = filebase.replace('.', '_') + ".txt"
//			if (m.genPath!=null && !m.genPath.empty)
//				dotfile = m.genPath + "/" + dotfile
			for(pres : m.presentations) {
// 				fsa.generateFile(pres.name + ".txt", pres.generate)
				FileHelper::save(pres.targetFolder, "index.html", pres.generate.toString)
 			}
 		}
	}
	
	def private generate (Presentation pres) {
		// prepare some substitutions
		var substitutions = new HashMap<String,String>
		substitutions.put("%%TITLE%%", pres.title)
		substitutions.put("%%DESCRIPTION%%",
			if (pres.description!=null) pres.description else "reveal.js presentation generated by remix"
		)
		substitutions.put("%%THEME%%",
			if (pres.theme!=null) pres.theme.name else "default"
		)
		substitutions.put("%%AUTHOR%%", pres.author)

		substitutions.put("%%CSS_NEEDS%%", pres.neededCSS)
		
		// generate html
		val out = pres.genAll(substitutions)
		
		// copy resources from used modules
		for(m : pres.parts.map[modules].flatten) {
			val srcdir = m.parentFolder + File::separator + RESOURCE_FOLDER
			val src = new File(srcdir)
			val targetdir = pres.targetFolder + File::separator + RESOURCE_FOLDER
			println("copy from" + sep + "  " + srcdir + " to" + sep + "  " + targetdir)
			if (src.exists && src.directory) {
				FileHelper::copyFolder(src, new File(targetdir.toString))
			}
		}
		
		// return generated html
		return out
	}

	def private genAll (Presentation pres, Map<String,String> substitutions) '''
		�FOR p : pres.parts�
		�IF p.title!=null�
			�p.genTitle(pres.partattr)�
		�ELSE�
			�IF p.overview�
				�pres.genOverview(pres.partattr)�
			�ENDIF�
		�ENDIF�
		�p.genPartContents(substitutions)�
		�ENDFOR�
	'''

	def private genOverview (Presentation pres, String attr) '''
		<!-- Overview generated by remix -->
		<section�IF attr!=null� �attr��ENDIF�>
			<h2>Overview</h2>
			<ol>
				�FOR p : pres.parts.filter[title!=null]�
				<li>�p.title�</li>
				�ENDFOR�
			</ol>
		</section>
		
	'''
	
	def private genTitle (Part part, String attr) '''
		<section�IF attr!=null� �attr��ENDIF�>
			<h2>�part.title�</h2>
			<hr>
			�IF part.image!=null�
			<img width="400" src="�RESOURCE_FOLDER�/�part.image�">
			�ENDIF�
		</section>

	'''	

	def private genPartContents (Part part, Map<String,String> substitutions) '''
		�FOR m : part.modules�
		<!-- �m.name� @ �m.filename� -->
		�m.filename.loadFile.replace(substitutions)�

		�ENDFOR�
	'''
	
	def private getTargetFolder (Presentation it) {
		val f = new File(target)
		val targetAbs = 
			if (f.absolute) {
				target
			} else {
				parentFolder + File::separator + target
			}
		targetAbs + File::separator + name
	}

	def private getParentFolder (Module it) {
		if (collection.path!=null)
			collection.path
		else {
			collection.parentFolderAux
		}
	}

	def private getParentFolder (Presentation it) {
		parentFolderAux
	}
	
	def private getParentFolderAux (EObject it) {
		val folder = CommonPlugin::resolve(eResource.URI).trimSegments(1)
		folder.path
	}

	def private getCollection (Module it) {
		(eContainer as Collection)
	}

	def private String getFilename (Module it) {
		parentFolder + File::separator + file
	}
	
	def private String getNeededCSS (Presentation it) '''
		�FOR css : collectNeededCSS�
		<link rel="stylesheet" href="�css.file�">
		�ENDFOR�
	'''

	def private collectNeededCSS (Presentation it) {
		parts.map[modules].flatten
			.map[dependencies].flatten.toSet
			.filter[type==DependencyType::CSS]
	}

	def private loadFile (String filename) {
		var file = new File(filename)
 		var content = new StringBuffer
 		var BufferedReader reader = null
 
 		try {
  			reader = new BufferedReader(new FileReader(file))
  			var String s = null
 
			while ((s = reader.readLine()) != null) {
				content.append(s).append(sep)
			}
		} catch (FileNotFoundException e) {
 			throw e
		} catch (IOException e) {
 			throw e
		} finally {
			try {
				if (reader != null) {
					reader.close
				}
			} catch (IOException e) {
			}
		}
		return content.toString
	}
	
	def private replace (String in, Map<String, String> subst) {
		var String out = in
		for(s : subst.keySet) {
			out = out.replaceAll(s, subst.get(s))	
		}
		out
	}
	
	def private getSep() {
		System::getProperty("line.separator")
	}

}

