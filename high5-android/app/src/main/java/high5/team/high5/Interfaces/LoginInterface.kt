package high5.team.high5.Interfaces

import android.content.Intent
import high5.team.high5.Activity.LoginActivity

interface LoginInterface{
    var context : LoginActivity

    fun init()
    fun signIn()
    fun checkUser()
    fun onSignInResult(requestCode: Int, resultCode: Int, data: Intent?)
}