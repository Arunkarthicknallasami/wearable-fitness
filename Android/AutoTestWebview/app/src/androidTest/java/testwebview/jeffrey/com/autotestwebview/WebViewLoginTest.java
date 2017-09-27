package testwebview.jeffrey.com.autotestwebview;

import android.support.test.espresso.web.webdriver.DriverAtoms;
import android.support.test.espresso.web.webdriver.Locator;
import android.support.test.filters.LargeTest;
import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.matcher.ViewMatchers.withText;
import static android.support.test.espresso.web.assertion.WebViewAssertions.webMatches;
import static android.support.test.espresso.web.sugar.Web.onWebView;
import static android.support.test.espresso.web.webdriver.DriverAtoms.clearElement;
import static android.support.test.espresso.web.webdriver.DriverAtoms.findElement;
import static android.support.test.espresso.web.webdriver.DriverAtoms.getText;
import static android.support.test.espresso.web.webdriver.DriverAtoms.webClick;
import static org.hamcrest.Matchers.containsString;

/**
 * Created by jeffrey on 6/8/17.
 */

@LargeTest
@RunWith(AndroidJUnit4.class)
public class WebViewLoginTest {

    @Rule
    public ActivityTestRule<MainActivity> mActivityRule = new ActivityTestRule<MainActivity>(
            MainActivity.class, true, true) {
        @Override
        protected void afterActivityLaunched() {
            // some works to do here
        }
    };


    @Test
    public void moveLogon() throws Exception {
        onView(withText("Start WebView")).perform(click());
        Thread.sleep(500);

        onWebView().forceJavascriptEnabled();
        Thread.sleep(500);

        onWebView()
                .withElement(findElement(Locator.XPATH, "//*[@id=\"ngview\"]/ng-view/div/div[4]/div"))
                .perform(webClick());
        Thread.sleep(500);

        onWebView()
                .withElement(findElement(Locator.XPATH, "//*[@id=\"ngview\"]/ng-view/div/div[6]/div/p/a/b"))
                .check(webMatches(getText(), containsString("Log In")))
                .perform(webClick());

        Thread.sleep(500);
        onWebView()
                .withElement(findElement(Locator.XPATH, "//*[@id=\"ngview\"]/ng-view/div/div[4]/div[2]/input"))
                .perform(clearElement())
                .perform(DriverAtoms.webKeys("jeffreyg"));

        Thread.sleep(500);

        onWebView()
                .withElement(findElement(Locator.XPATH, "//*[@id=\"ngview\"]/ng-view/div/div[5]/div[2]/input"))
                .perform(clearElement())
                .perform(DriverAtoms.webKeys("12345678jg"));
        Thread.sleep(500);

        onWebView()
                .withElement(findElement(Locator.XPATH, "//*[@id=\"ngview\"]/ng-view/div/div[7]/div[2]"))
                .check(webMatches(getText(), containsString("Log In")))
                .perform(webClick());
        Thread.sleep(5000);
    }
}
