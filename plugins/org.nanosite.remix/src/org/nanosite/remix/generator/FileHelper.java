package org.nanosite.remix.generator;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.eclipse.emf.common.util.URI;

public class FileHelper {

	/**
	 * Helper for saving a text to file
	 *
	 * @param targetDir   the target directory
	 * @param filename    the target filename
	 * @param textToSave  the content for the file
	 * @return true if ok
	 */
	public static boolean save (String targetDir, String filename, String textToSave) {
		// ensure that directory is available
		File dir = new File(targetDir);
		if (! (dir.exists() || dir.mkdirs())) {
			System.err.println("Error: couldn't create directory " + targetDir + "!");
			return false;
		}
		
		// delete file prior to saving
		File file = new File(targetDir + "/" + filename);
		file.delete();
		
		// save contents to file
	    try {
	        BufferedWriter out = new BufferedWriter(new FileWriter(file));
	        out.write(textToSave);
	        out.close();
	        System.out.println("Created file " + file.getAbsolutePath());
	    } catch (IOException e) {
	    	return false;
	    }
	    
	    return true;
	}

	/**
	 * Platform-independent helper to create URIs from file names.
	 * 
	 * Rationale: createFileURI is platform-dependent and doesn't work
	 * for absolute paths on Unix and MacOS. This function provides 
	 * createURI from file paths for Unix, MacOS and Windows.
	 */
	public static URI createURI(String filename) {
		URI uri = URI.createURI(filename);

		String os = System.getProperty("os.name");
		boolean isWindows = os.startsWith("Windows");
		boolean isUnix = !isWindows; // this might be too clumsy...
		if (uri.scheme() != null) {
			// If we are under Windows and s starts with x: it is an absolute path
			if (isWindows && uri.scheme().length() == 1) {
				return URI.createFileURI(filename);
			}
			// otherwise it is a proper URI
			else {
				return uri;
			}
		}
		// Handle paths that start with / under Unix e.g. /local/foo.txt
		else if (isUnix && filename.startsWith("/")) { 
			return URI.createFileURI(filename);
		}
		// otherwise it is a proper URI
		else {
			return uri;
		}
	}


	/**
	 * Helper function to copy a folder's contents recursively.
	 * 
	 * @param sourceLocation the source folder
	 * @param targetLocation the target location
	 * @throws IOException
	 */
	public static void copyFolder (File sourceLocation, File targetLocation) throws IOException {
	    if (sourceLocation.isDirectory()) {
	        if (!targetLocation.exists()) {
	            targetLocation.mkdir();
	        }

	        String[] children = sourceLocation.list();
	        for (int i=0; i<children.length; i++) {
	            copyFolder(new File(sourceLocation, children[i]),
	                    new File(targetLocation, children[i]));
	        }
	    } else {

	        InputStream in = new FileInputStream(sourceLocation);
	        OutputStream out = new FileOutputStream(targetLocation);

	        // Copy the bits from instream to outstream
	        byte[] buf = new byte[1024];
	        int len;
	        while ((len = in.read(buf)) > 0) {
	            out.write(buf, 0, len);
	        }
	        in.close();
	        out.close();
	    }
	}
}
