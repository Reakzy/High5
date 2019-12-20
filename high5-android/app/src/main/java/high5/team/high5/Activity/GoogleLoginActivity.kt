package high5.team.high5.Activity

import android.content.Intent
import android.support.v4.app.ActivityCompat.startActivityForResult
import android.util.Log
import android.widget.Toast
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.api.GoogleApiClient
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.GoogleAuthProvider
import high5.team.high5.Adapter.UserAdapter
import high5.team.high5.Interfaces.LoginInterface
import high5.team.high5.Model.User
import high5.team.high5.Utils.Date
import java.util.*

class GoogleLoginActivity(override var context: LoginActivity) : LoginInterface, GoogleApiClient.OnConnectionFailedListener {
    private val TAG = "GoogleLoginActivity"

    private val REQUEST_CODE_SIGN_IN = 1
    private val WEB_CLIENT_ID = "210036091979-q6j5tjc0ueukuhat14f1n720q7hdeq8h.apps.googleusercontent.com"

    private var mAuth: FirebaseAuth? = null

    private var mGoogleApiClient: GoogleApiClient? = null
    private var userAdapter: UserAdapter = UserAdapter()

    private var user = User()

    override fun init() {
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(WEB_CLIENT_ID)
            .requestEmail()
            .build()

        mGoogleApiClient = GoogleApiClient.Builder(context)
            .enableAutoManage(context /* FragmentActivity */, this /* OnConnectionFailedListener */)
            .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
            .build()

        mAuth = FirebaseAuth.getInstance()
    }

    override fun onConnectionFailed(p0: ConnectionResult) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun signIn() {
        val intent = Auth.GoogleSignInApi.getSignInIntent(mGoogleApiClient)
        startActivityForResult(context, intent, REQUEST_CODE_SIGN_IN, null)
    }

    override fun checkUser() {
        val userGoogle = mAuth?.currentUser
        if (null !== userGoogle?.uid) {
            userAdapter.getUserById(userGoogle.uid) {
                val userDb = userAdapter.getUser()
                if (null !== userDb) {
                    goToEventList(userDb)
                } else {
                    val intent = Intent(context, ProfileEditActivity::class.java)
                    val newUser = User()

                    val date = Date()
                    newUser.id = userGoogle.uid
                    newUser.email = userGoogle.email!!
                    newUser.fullName = userGoogle.displayName!!
                    newUser.createdAt = date.utcDate("MM-dd-yyyy HH:mm")
                    newUser.profilePicture = userGoogle.photoUrl.toString()
                    intent.putExtra("User", newUser)
                    intent.putExtra("isNewUser", true)
                    context.startActivity(intent)
                }
            }
        }
    }

    override fun onSignInResult(requestCode: Int, resultCode: Int, data: Intent?) {
        // Result returned from launching the Intent from GoogleSignInApi.getSignInIntent();
        if (requestCode == REQUEST_CODE_SIGN_IN) {
            val result = Auth.GoogleSignInApi.getSignInResultFromIntent(data)
            if (result.isSuccess) {
                // successful -> authenticate with  Firebase
                val account = result.signInAccount
                firebaseAuthWithGoogle(account!!)
            } else {
                Toast.makeText(context, "SignIn: Failed!",
                    Toast.LENGTH_SHORT).show()
            }
        }
    }


    private fun firebaseAuthWithGoogle(acct: GoogleSignInAccount) {
        val credential = GoogleAuthProvider.getCredential(acct.idToken, null)
        mAuth!!.signInWithCredential(credential)
            .addOnCompleteListener(context) { task ->
                if (task.isSuccessful) {
                    Log.e(TAG, "signInWithCredential: Success!")
                    val userGoogle = mAuth!!.currentUser

                    userAdapter.getUserById(userGoogle!!.uid) {
                        val userDb = userAdapter.getUser()
                        if (null !== userDb) {
                            goToEventList(userDb)
                        } else {
                            val intent = Intent(context, ProfileEditActivity::class.java)
                            val newUser = User()

                            val date = Date()
                            newUser.id = userGoogle.uid
                            newUser.email = userGoogle.email!!
                            newUser.fullName = userGoogle.displayName!!
                            newUser.createdAt = date.utcDate("MM-dd-yyyy HH:mm")
                            newUser.profilePicture = userGoogle.photoUrl.toString()
                            intent.putExtra("User", newUser)
                            intent.putExtra("isNewUser", true)
                            context.startActivity(intent)
                        }
                    }
                }
                else {
                    Toast.makeText(context, "SignInWithCredential: Failed!",
                        Toast.LENGTH_SHORT).show()
                }
            }
    }

    private fun goToEventList(user: User?) {
        if (user != null) {
            val intent = Intent(context, EventActivity::class.java)
            intent.putExtra("User", user)
            context.startActivity(intent)
        }
    }
}
