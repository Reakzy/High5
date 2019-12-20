package high5.team.high5

import android.widget.EditText
import com.google.android.gms.common.ConnectionResult
import high5.team.high5.Activity.*
import high5.team.high5.Model.Event
import high5.team.high5.Model.Message
import high5.team.high5.Model.User
import high5.team.high5.Utils.Date
import org.junit.Test
import java.util.*

class EventUnitTest {

    val event = Event()
    val user = User()
    val message = Message()
    val buildConfig = BuildConfig()

    val date = Date()
    @Test
    fun ModelTest(){
        event.addUserId("test")
        event.addWaitingUserId("test")
        event.isInEvent("test")
        event.removeUserId("test")
        event.removeWaitingUserId("test")
    }

    @Test
    fun utilTest(){
        val editText : EditText
        date.getCalendar("01/12/1992 12:01", Calendar.getInstance())
        date.transformDbToView("03-16-2019 17:59:03.040")
        date.updateDate("dd/MM/yyyy HH:mm", Calendar.getInstance())
        date.utcDate()

    }

    @Test
    fun eventActivityTest() {
        val eventActivity = EventActivity()
        eventActivity.onBackPressed()
    }

    @Test
    fun chatActivityTest() {
        val chatActivity = ChatActivity()
    }

    @Test
    fun eventCreateActivityTest() {
        val eventCreateActivity = EventCreateActivity()
    }

    @Test
    fun eventDetailsActivityTest() {
        val eventDetailsActivity = EventDetailsActivity()
    }
    @Test
    fun eventWaitingQueueActivityTest() {
        val eventWaitingQueueActivity = EventWaitingQueueActivity()
    }

    @Test
    fun googleLoginActivityTest() {
        val googleLoginActivity = GoogleLoginActivity(LoginActivity())
    }

    @Test
    fun loginActivityTest() {
        val loginActivity = LoginActivity()
        val connectionResult : ConnectionResult = ConnectionResult.RESULT_SUCCESS
    }

    @Test
    fun profileActivityTest(){
        val profileActivity = ProfileActivity()
    }

    @Test
    fun profileEditActivityTest(){
        val profileEditActivity = ProfileEditActivity()
    }

}
