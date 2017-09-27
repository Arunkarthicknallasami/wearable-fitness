package com.jeffrey.testmodule;

import com.google.common.hash.Hashing;

import java.nio.charset.StandardCharsets;

/**
 * Created by Jeffrey Garcia Wong on 9/27/2017.
 */

public class Module {

    public static String generateSha256Checksum(final String inputString) {
        String checksum;
        checksum = Hashing.sha256().hashString(inputString, StandardCharsets.UTF_8).toString();
        return checksum;
    }

}
