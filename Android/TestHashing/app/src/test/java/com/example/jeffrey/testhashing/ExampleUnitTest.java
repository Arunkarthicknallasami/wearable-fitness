package com.example.jeffrey.testhashing;

import org.junit.Test;

import java.util.Locale;

import static org.junit.Assert.*;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class ExampleUnitTest {
    @Test
    public void addition_isCorrect() throws Exception {
        assertEquals(4, 2 + 2);
    }

    @Test
    public void validate_checksum() throws Exception {
        String input = "testing 123";
        String checksum = ChecksumUtil.validateChecksum(input);
        assertEquals("CC6004BB7AB40E52A92928146FFDB32F10D48C599D5FBF9A7EAA4E3623EC7D69".toLowerCase(), checksum.toLowerCase());
    }

    @Test
    public void validate_locale() throws Exception {
        Locale locale = new Locale("zh", "HK");
        String language = locale.getLanguage();
        String tag = locale.toLanguageTag();
        assertNotNull(locale);
    }
}