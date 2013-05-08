/*
 * Copyright 2013 The Sculptor Project Team, including the original 
 * author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.sculptor.generator.formatter

import org.junit.Test
import static org.junit.Assert.*

class CodeAutoImporterTest {

	@Test
	def testReplaceQualifiedTypes() {
		val source = new CodeAutoImporter().replaceQualifiedTypes(
			'''
				package com.acme;
				
				/// Insert imports here ///
				
				class Test {
					private java.util.Map<java.lang.String, java.lang.String> map = new java.util.HashMap<java.lang.String, java.lang.String>();
				
					public Test(com.acme.Foo foo) {
					com.acme.Foo bar = foo;
					map.put((java.lang.String) "foobar", (java.lang.String) bar.toString());
					com.acme.foo.Foo bar;	// conflict
					}
				}
			''', '/// Insert imports here ///')
		assertEquals(
			'''
				package com.acme;
				
				import com.acme.Foo;
				import java.util.Map;
				import java.lang.String;
				import java.util.HashMap;
				
				
				class Test {
					private Map<String, String> map = new HashMap<String, String>();
				
					public Test(Foo foo) {
					Foo bar = foo;
					map.put((String) "foobar", (String) bar.toString());
					com.acme.foo.Foo bar;	// conflict
					}
				}
			'''.toString, source)
	}
}