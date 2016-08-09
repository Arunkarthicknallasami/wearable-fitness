/**
 * PostAPNS.java
 * Sender program for out-bound push notification to APNS
 * 
 * Created by Jeffrey Garcia on 8/6/16.
 * Copyright © 2016 Jeffrey Garcia. All rights reserved.
 * 
 * Pre-requisite
 * - enable push notification capability of the app in Xcode
 * - create both dev/prod certificate of the target app ID in Apple Developer Website
 * - download the certificates, import to Keychain then export the P12 file
 * - run the app in device to obtain the device Token from debug loggings
 * - the P12 file will be needed to authenticate the request with APNS while the device 
 *   token will be needed to route the notification to the device
 * 
 * Reference:
 * https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW4  
 */

package com.jeffrey.mobile.apns.push;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.Date;
import java.util.Map;

import org.apache.commons.codec.binary.Hex;

import com.notnoop.apns.APNS;
import com.notnoop.apns.ApnsDelegateAdapter;
import com.notnoop.apns.ApnsNotification;
import com.notnoop.apns.ApnsService;
import com.notnoop.apns.ApnsServiceBuilder;
import com.notnoop.apns.DeliveryError;
import com.notnoop.apns.PayloadBuilder;
import com.notnoop.apns.internal.Utilities;
import com.notnoop.exceptions.ApnsDeliveryErrorException;

public class PostAPNS {
	protected static final String DEVICE_TOKEN = "ed57f396f87b24bab811ecaf9669820697a5ba96f17539734af52c3c343a524e";
	protected static final String DEV_P12_FILE = "apns_dev_jeffrey.p12";
	
	public static void main(String [] args) {
		try {
			send();
		} catch (Exception exc) {
			exc.printStackTrace();
		}
	}
	
	public static void send() throws Exception {
		copyP12toRuntimePath();
		pushMessageWithCallback();
	}
	
	protected static void copyP12toRuntimePath() throws Exception {
		File runtime = new File(PostAPNS.class.getProtectionDomain().getCodeSource().getLocation().getPath());
		String targetPath = runtime.getAbsolutePath();
		
		String sourcePath;
		sourcePath = targetPath.substring(0, targetPath.indexOf("bin"));
		sourcePath = sourcePath + "res" + File.separator + DEV_P12_FILE;
		//path = path + "apns_dev_jeffrey.p12";
		File source = new File(sourcePath);
		
		targetPath = targetPath + File.separator + DEV_P12_FILE;
		File target = new File(targetPath);
		if (!target.exists() && !source.exists()) {
			throw new Exception("P12 file cannot be found!");
		}
		
		Files.copy(source.toPath(), target.toPath(), REPLACE_EXISTING);
	}
	
	protected static void pushMessageWithCallback() throws Exception {
		final ApnsServiceBuilder builder = APNS.newService();
		
		// using the APNS Delegate callback to log success/failure for each token:
        builder.withDelegate(new ApnsDelegateAdapter() {
        	public void messageSent(ApnsNotification message, boolean resent) {
        		System.out.println("@ device token in HEX string: " + Hex.encodeHexString(message.getDeviceToken()));
        		System.out.println("@ message sent, resent? " + resent);
        	}

			@Override
			public void connectionClosed(DeliveryError err, int messageIdentifier) {
				System.err.println("@ connection closed, error code: " + err.code() + " message id: " + messageIdentifier);
			}

			@Override
			public void messageSendFailed(ApnsNotification message, Throwable exc) {
				System.err.println("@ message sent failed");
				
				if (exc.getClass().isAssignableFrom(ApnsDeliveryErrorException.class)) {
                    ApnsDeliveryErrorException deliveryError = (ApnsDeliveryErrorException) exc;
                    if (DeliveryError.INVALID_TOKEN.equals(deliveryError.getDeliveryError())) {
                        final String invalidToken = Utilities.encodeHex(message.getDeviceToken()).toLowerCase();
                        System.err.println("Removing invalid token: " + invalidToken);
                        
                    } else {
                        // for now, we just log the other cases
                        exc.printStackTrace();
                    }
                }
			}
        });
        
        InputStream certStream = PostAPNS.class.getClassLoader().getResourceAsStream(DEV_P12_FILE);
        builder.withCert(certStream, "password").withSandboxDestination();
        
        pushMessage(builder);
	}
	
	protected static void pushMessage(final ApnsServiceBuilder builder) throws Exception {
		ApnsService service = null;
		
		// create the service
        service = builder.build();
        
        service.start();
        
		/* You may have to delete the devices from you list that no longer 
		 * have the app installed, see method below
		 */
		deleteInactiveDevices(service);
		
		/* we had a daily update here, so we need to know how many 
		 * days the user hasn't started the app, so that we get the 
		 * number of updates to display it as the badge.
		 * int days = (int) ((System.currentTimeMillis() - 
		 * user.getLastUpdate()) / 1000 / 60 / 60 / 24);
		 */
		PayloadBuilder payloadBuilder = APNS.newPayload();
		payloadBuilder = payloadBuilder.badge(1).alertBody("some message you want to send here").category("INVITE_CATEGORY");
		
		// check if the message is too long (it won't be sent if it is) and trim it if it is. 
		if (payloadBuilder.isTooLong()) {
			payloadBuilder = payloadBuilder.shrinkBody();
		}
		
		String payload = payloadBuilder.build();
		
		service.push(DEVICE_TOKEN, payload);
	}
	
	protected static void deleteInactiveDevices(ApnsService service) throws Exception {
		/* get the list of the devices that no longer have your app installed 
		 * from apple
		 * ignore the ="" after Date here, it's a bug...
		 */
		Map<String, Date> inactiveDevices = service.getInactiveDevices();
		for (String deviceToken : inactiveDevices.keySet()) {
			System.out.println("inactivate device token for service: " + deviceToken);
		}
	}
}
