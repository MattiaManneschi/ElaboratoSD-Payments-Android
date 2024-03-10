package com.example.wally_app;
import static java.sql.DriverManager.println;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import java.io.UnsupportedEncodingException;
import java.util.Objects;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import it.nexi.xpay.CallBacks.FrontOfficeCallbackQP;
import it.nexi.xpay.Models.WebApi.Errors.ApiErrorResponse;
import it.nexi.xpay.Models.WebApi.Requests.FrontOffice.ApiFrontOfficeQPRequest;
import it.nexi.xpay.Models.WebApi.Responses.FrontOffice.ApiFrontOfficeQPResponse;
import it.nexi.xpay.Utils.EnvironmentUtils;
import it.nexi.xpay.Utils.Exceptions.DeviceRootedException;
import it.nexi.xpay.Utils.Exceptions.MacException;
import it.nexi.xpay.Utils.QPUtils.CurrencyUtilsQP;
import it.nexi.xpay.Utils.XPayLogger;
import it.nexi.xpay.XPay;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "nexi.payment/gateway";

    private MethodChannel.Result myResult;

    private final Backend backend = new Backend();

    String secret_key = backend.getSecret_key();
    String alias = backend.getAlias();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (Objects.equals(call.method, "pay")) {
                        try {
                            Activity myActivity = getActivity();
                            XPay xPay = new XPay(myActivity, secret_key);
                            myResult = result;
                            pay(xPay, call.argument("amount"));
                        } catch (DeviceRootedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
        );
    }
    private void pay(XPay xPay, int amount) {
        XPayLogger.DEBUG = true;
        xPay.GestioneContratti.setDomain("https://ecommerce.nexi.it");
        xPay.GestioneContratti.setEnvironment(EnvironmentUtils.Environment.TEST);

        ApiFrontOfficeQPRequest apiFrontOfficeQPRequest = null;

        String code = getCodTrans();

        try{
            apiFrontOfficeQPRequest = new ApiFrontOfficeQPRequest(alias, code, CurrencyUtilsQP.EUR, amount);
        }catch(UnsupportedEncodingException | MacException e){
            e.printStackTrace();
        }

        assert apiFrontOfficeQPRequest != null;
        xPay.FrontOffice.paga(apiFrontOfficeQPRequest, true, new FrontOfficeCallbackQP() {
            @Override
            public void onCancel(ApiFrontOfficeQPResponse response) {
                Log.i("XPAY", "Operazione annullata dall'utente.");
                myResult.success(0);
            }

            @Override
            public void onConfirm(ApiFrontOfficeQPResponse response) {
                if(response.isValid()){
                    Log.i("XPAY", "Operazione confermata.");
                    myResult.success(amount/50);

                }else{
                    Log.i("XPAY", "La risposta non è valida.");
                    myResult.success(0);
                }
            }

            @Override
            public void onError(ApiErrorResponse error) {
                Log.i("XPAY", "Errore.");
                myResult.success(0);
            }
        });
    }

    private String getCodTrans(){
        String alpha = "ABCDEFGHILMNOPQRSTUVZ" + "0123456789";

        StringBuilder sb = new StringBuilder(10);

        for (int i = 0;i<10; i++){
            int index = (int)(alpha.length()*Math.random());

            sb.append(alpha.charAt(index));
        }

        return sb.toString();

    }

};


