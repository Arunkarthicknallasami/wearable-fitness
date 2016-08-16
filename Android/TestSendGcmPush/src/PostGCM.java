import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.commons.io.IOUtils;
import org.json.JSONObject;

public class PostGCM {
	
	public static void main(String [] args) {
		//API key provided by Google Console
		//578005844236 <!-- Jeffrey personal sender ID -->
		String apiKey = "AIzaSyBScB61QCzaFwlPISOaP9sivsxrFSiSERw"; // Jeffrey's personal
		
		//GCM Registration Token: 
		//dUtWTYoFZqU:APA91bFBhJ1i9SwGxrqvvmNs09S2XftxRPZLJOEXFV-d6TNGwkKGtTSWssT_5eA_M1gBIMvYYUMfKBclSbrfcRzCEl1A5Vvq7aczr95KVoV34KLCuEuvujD5wEqBS_bC1swpyv-k5Jq7
		
		args = new String [] {"testing msg from Eclipse", 
				"dUtWTYoFZqU:APA91bFBhJ1i9SwGxrqvvmNs09S2XftxRPZLJOEXFV-d6TNGwkKGtTSWssT_5eA_M1gBIMvYYUMfKBclSbrfcRzCEl1A5Vvq7aczr95KVoV34KLCuEuvujD5wEqBS_bC1swpyv-k5Jq7"};
		//args = new String [] {"testing msg from Eclipse"};
		
        // Prepare JSON containing the GCM message content. What to send and where to send.
        JSONObject jGcmData = new JSONObject();
        JSONObject jData = new JSONObject();
        jData.put("message", args[0]); // fields required by new GCM endpoint
//        jData.put("id", "B2000000099"); // fields required by legacy C2DM Post Request
//        jData.put("body", "body"); // fields required by legacy C2DM Post Request
//        jData.put("param", "e:003,c:sp"); // fields required by legacy C2DM Post Request
        
        // Where to send GCM message.
        if (args.length > 1 && args[1] != null) {
        	//jGcmData.put("registration_ids", new String[] {args[1].trim()}); // legacy C2DM Post Request
            jGcmData.put("to", args[1].trim()); // new GCM Post Request
        } else {
            jGcmData.put("to", "/topics/global");
        }
        // What to send in GCM message.
        jGcmData.put("data", jData);
		System.out.println(jGcmData);
		
		try {
			URL url;
			//url = new URL("https://android.googleapis.com/gcm/send"); // legacy C2DM endpoint
			url = new URL("https://gcm-http.googleapis.com/gcm/send"); // new GCM endpoint
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Authorization", "key="+apiKey); 
			conn.setDoOutput(true);
			
			System.out.println("\nSending 'POST' request to URL : " + url);
			
            // Send GCM message content.
            OutputStream outputStream = conn.getOutputStream();
            outputStream.write(jGcmData.toString().getBytes());
			
			int responseCode = conn.getResponseCode();
	        System.out.println("Response Code : " + responseCode);
            
            // Read GCM response.
            InputStream inputStream = conn.getInputStream();
            String resp = IOUtils.toString(inputStream);
            System.out.println(resp);
            System.out.println("Check your device/emulator for notification or logcat for " +
                    "confirmation of the receipt of the GCM message.");
            
	        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        String inputLine; 
	        StringBuffer response = new StringBuffer();
	        while ((inputLine = in.readLine()) != null) {
	            response.append(inputLine);
	        }
	        in.close();
	        
	        // 7. Print result
	        System.out.println(response.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
