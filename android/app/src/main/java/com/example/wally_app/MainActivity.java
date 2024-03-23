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
    private static final String CHANNEL = "nexi.payment/gateway"; // platform channel di collegamento con wallet.dart

    private MethodChannel.Result myResult;

    private final Backend backend = new Backend();

    String secret_key = backend.getSecret_key(); // riceve i dati personali da un package a parte
    String alias = backend.getAlias();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (Objects.equals(call.method, "pay")) { // metodo call invocato dalla pagina wallet.dart
                        try {
                            Activity myActivity = getActivity(); // sessione corrente dell'applicazione
                            XPay xPay = new XPay(myActivity, secret_key); // inizializzazione oggetto di tipo XPay
                            myResult = result; // dichiarazione aggiuntiva, serve per aspettare effettivamente il risultato di pay(...), prima di restituire qualcosa
                            pay(xPay, call.argument("amount")); // l'importo viene preso dalla call 
                        } catch (DeviceRootedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
        );
    }
    private void pay(XPay xPay, int amount) {
        XPayLogger.DEBUG = true;
        xPay.GestioneContratti.setDomain("https://ecommerce.nexi.it"); // impostazione del dominio 
        xPay.GestioneContratti.setEnvironment(EnvironmentUtils.Environment.TEST); // impostazione dell'ambiente

        ApiFrontOfficeQPRequest apiFrontOfficeQPRequest = null;

        String code = getCodTrans(); // codice di transazione generico a 10 cifre

        try{
            apiFrontOfficeQPRequest = new ApiFrontOfficeQPRequest(alias, code, CurrencyUtilsQP.EUR, amount); //invocazione dell'api Nexi con tutti i parametri raccolti
        }catch(UnsupportedEncodingException | MacException e){
            e.printStackTrace();
        }

        assert apiFrontOfficeQPRequest != null;
        xPay.FrontOffice.paga(apiFrontOfficeQPRequest, true, new FrontOfficeCallbackQP() {
            @Override
            public void onCancel(ApiFrontOfficeQPResponse response) {
                Log.i("XPAY", "Operazione annullata dall'utente.");
                myResult.success(0); //altrimenti ritorna 0 punti
            }

            @Override
            public void onConfirm(ApiFrontOfficeQPResponse response) {
                if(response.isValid()){
                    Log.i("XPAY", "Operazione confermata.");
                    myResult.success(amount/50); //se l'operazione va a buoni fine il risultato sono i punti legati all'importo speso

                }else{
                    Log.i("XPAY", "La risposta non è valida.");
                    myResult.success(0); //altrimenti ritorna 0 punti
                }
            }

            @Override
            public void onError(ApiErrorResponse error) {
                Log.i("XPAY", "Errore.");
                myResult.success(0); //altrimenti ritorna 0 punti
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


