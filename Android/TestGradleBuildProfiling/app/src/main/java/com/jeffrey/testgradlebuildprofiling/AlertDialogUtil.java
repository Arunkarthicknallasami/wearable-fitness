package com.jeffrey.testgradlebuildprofiling;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.os.Build;
import android.util.Log;

/**
 * Created by Jeffrey Garcia Wong on 9/3/2017.
 */

public class AlertDialogUtil {

    private static AlertDialog alertDialog;

    public static void showDialog(final Activity context) {
        if (alertDialog != null && alertDialog.isShowing()) {
            final Context ownerContext = ((ContextWrapper)alertDialog.getContext()).getBaseContext();
            if (ownerContext instanceof Activity) {
                if (!((Activity) ownerContext).isFinishing() && !((Activity) ownerContext).isDestroyed()) {
                    // the owner activity still exist
                    alertDialog.dismiss();
                } else {
                    Log.w("AlertDialogUtil", "owner activity does not exist");
                }
            } else {
                alertDialog.dismiss();
            }

            alertDialog = null;
        }

        final AlertDialog.Builder builder;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            builder = new AlertDialog.Builder(context, android.R.style.Theme_Material_Dialog_Alert);
        } else {
            builder = new AlertDialog.Builder(context);
        }
        builder.setTitle("Delete entry")
                .setMessage("Are you sure you want to delete this entry?")
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // continue with delete
                    }
                })
                .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // do nothing
                    }
                })
                .setIcon(android.R.drawable.ic_dialog_alert);

        alertDialog = builder.create();
        alertDialog.show();
    }

    public static boolean isShowing() {
        return alertDialog != null;
    }

}
