package com.jeffrey.testmodule;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

/**
 * Created by Jeffrey Garcia Wong on 9/27/2017.
 */

public class ModuleUnitTest {

    @Test
    public void ModuleTest() throws Exception {
        Module module = new Module();
        assertNotNull(module);
    }

    @Test
    public void checksumTest() throws Exception {
        String inputString = "testing 123";
        String checksum = Module.generateSha256Checksum(inputString);
        assertNotNull(checksum);
        assertEquals("cc6004bb7ab40e52a92928146ffdb32f10d48c599d5fbf9a7eaa4e3623ec7d69", checksum);
        //assertEquals("test", checksum); // simulate failure unit-test case
    }

}
