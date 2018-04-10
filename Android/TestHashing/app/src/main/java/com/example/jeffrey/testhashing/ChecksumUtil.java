package com.example.jeffrey.testhashing;

import com.google.common.hash.Hashing;

import java.nio.charset.StandardCharsets;

/**
 * Created by jeffrey on 11/9/2017.
 */

public class ChecksumUtil {


    public static String validateChecksum(final String jsonString) {
        String checksum;
        checksum = Hashing.sha256().hashString(jsonString, StandardCharsets.UTF_8).toString();
        return checksum;
    }


}
