package high5.team.high5.Activity

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.common.ConnectionResult
import android.content.Intent
import com.google.android.gms.ads.MobileAds
import com.google.firebase.FirebaseApp
import high5.team.high5.Interfaces.LoginInterface
import high5.team.high5.R
import kotlinx.android.synthetic.main.activity_login.*

class LoginActivity : AppCompatActivity(), View.OnClickListener, GoogleApiClient.OnConnectionFailedListener {

    private val TAG = "LoginActivity"

    private var login : LoginInterface = GoogleLoginActivity(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        FirebaseApp.initializeApp(this)
        MobileAds.initialize(this, "ca-app-pub-1737513588576197~4958054070")
        btnGoogle.setOnClickListener(this)
        login.init()
    }

    override fun onStart() {
        super.onStart()
        login.checkUser()
    }

    override fun onClick(v: View) {
        val i = v.id
        when (i) {
            R.id.btnGoogle -> login.signIn()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        login.onSignInResult(requestCode, resultCode, data)
    }


    override fun onConnectionFailed(connectionResult: ConnectionResult) {
        Log.e(TAG, "onConnectionFailed():$connectionResult");
        Toast.makeText(applicationContext, "Google Play Services error.", Toast.LENGTH_SHORT).show();
    }

}